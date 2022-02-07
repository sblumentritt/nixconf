#!/usr/bin/env sh

BOOT_DEVICE_PATH=""
BOOT_CRYPT_NAME="cryptboot"
BOOT_KEY_NAME="${BOOT_CRYPT_NAME}_keyfile.bin"

ROOT_DEVICE_PATH=""
ROOT_CRYPT_NAME="cryptroot"
ROOT_KEY_NAME="${ROOT_CRYPT_NAME}_keyfile.bin"

main() {
    # script should be run as root
    if [ "$(id -u)" -ne 0 ]; then
        printf "Please run as root!\n" 1>&2
        exit 1
    fi

    # show list of block devices for easier selection
    lsblk -a -o NAME,SIZE,MOUNTPOINT

    printf "\nOn which drive do you want to install the system? "
    read -r drive_path

    if [ -z "${drive_path}" ]; then
        printf "\nDrive path needs to be set and can not be empty!\n" 1>&2
        exit 1
    fi

    local mount_point="/mnt"

    local color='\033[33m' # yellow/orange
    local color_reset='\033[0m'

    printf "\n${color}[ Start partitioning ]${color_reset}\n"
    partition ${drive_path}

    printf "\n${color}[ Start formatting and mounting ]${color_reset}\n"
    format_and_mount ${drive_path} ${mount_point}
}

partition() {
    local drive_path=$1

    wipefs --all --force "${drive_path}"

    (
    printf "%s\n" "g" # create a new empty GPT partition table
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (1)
    printf "%s\n" "" # default first sector
    printf "%s\n" "+550M" # partition size for EFI (recommended size)
    printf "%s\n" "t" # change partition type
    printf "%s\n" "C12A7328-F81F-11D2-BA4B-00A0C93EC93B" # type: 'EFI'
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (2)
    printf "%s\n" "" # default first sector
    printf "%s\n" "+1G" # partition size for /boot
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (3)
    printf "%s\n" "" # default first sector
    printf "%s\n" "" # default last sector (remaining space)
    printf "%s\n" "w" # write changes
    ) | fdisk "${drive_path}"

    sleep 2s # TODO: why? Do we have to wait for the partitioning to take effect?
}

format_and_mount() {
    local drive_path=$1
    local mount_point=$2

    local boot_crypt_path="/dev/mapper/${BOOT_CRYPT_NAME}"
    local root_crypt_path="/dev/mapper/${ROOT_CRYPT_NAME}"

    lsblk "${drive_path}"
    # as it is unpredictable how the drives are named (sdxY,mmcblkxpY,nvme0nxpY)
    # -> https://wiki.archlinux.org/index.php/Device_file
    # it is much safer to just ask the user for the partition paths
    printf "Please enter the 'efi' partition path: "
    read -r efi_partition

    printf "Please enter the 'boot' partition path: "
    read -r boot_partition
    BOOT_DEVICE_PATH="${boot_partition}"

    printf "Please enter the 'root' partition path: "
    read -r root_partition
    ROOT_DEVICE_PATH="${root_partition}"

    # encrypt the boot partition with LUKS1 because GRUB cannot handle LUKS2 correctly
    printf "\nSetup encryption for the 'boot' partition:\n"
    cryptsetup luksFormat --type luks1 "${boot_partition}"
    # use predefined UUID because luks1 doesn't support labels and we need to define
    # the partition path in the hardware.nix somehow and this should be generic
    # NOTE: for consistency every partition gets predefined UUIDs
    cryptsetup luksUUID --uuid cf22708f-b675-4971-8884-9183ede13770 "${boot_partition}"

    # use LUKS2 for the root partition
    printf "\nSetup encryption for the 'root' partition:\n"
    cryptsetup luksFormat --type luks2 "${root_partition}"
    cryptsetup luksUUID --uuid 9f5674cd-f11b-49c7-a975-ee981a0c56b5 "${root_partition}"

    # open the encrypted partitions which will be mapped to /dev/mapper/<name>
    printf "\nUnlocking 'boot' partition, passphrase has to be entered:\n"
    cryptsetup open "${boot_partition}" "${BOOT_CRYPT_NAME}"
    printf "\nUnlocking 'root' partition, passphrase has to be entered:\n"
    cryptsetup open "${root_partition}" "${ROOT_CRYPT_NAME}"

    # format partitions
    mkfs.fat -F32 -n "efi" "${efi_partition}" # will not have an UUID change
    mkfs.btrfs -f -L "boot" "${boot_crypt_path}"
    btrfstune -M e0a63f79-df23-469f-9d64-05983cb32512 "${boot_crypt_path}"
    mkfs.btrfs -f -L "root" "${root_crypt_path}"
    btrfstune -M f7cfbda7-2577-4d5f-9056-138b2e4209ed "${root_crypt_path}"

    # create subvolumes
    mount -t btrfs ${root_crypt_path} ${mount_point}
    (
        cd "${mount_point}" || exit

        btrfs subvolume create "test"
        btrfs subvolume create "test/root"
        btrfs subvolume create "test/home"
        btrfs subvolume create "test/var"
        btrfs subvolume create "test/nix"
    )

    umount -R ${mount_point}

    # mount subvolumes on correct positions with the correct options
    local common_mount_options="noatime,space_cache,commit=120"

    mount -o "${common_mount_options},compress=zstd,subvol=test/root" \
        ${root_crypt_path} ${mount_point}

    # define variables to create folders needed for the mount
    local IFS=','
    local wanted_folder="efi,boot,home,var,nix"

    for folder in $wanted_folder; do
        mkdir -p "${mount_point}/${folder}"
    done

    mount ${efi_partition} ${mount_point}/efi
    mount -o "${common_mount_options},compress=lzo" ${boot_crypt_path} ${mount_point}/boot

    mount -o "${common_mount_options},compress=zstd,subvol=test/home" \
        ${root_crypt_path} ${mount_point}/home

    mount -o "${common_mount_options},compress=zstd,subvol=test/var" \
        ${root_crypt_path} ${mount_point}/var

    mount -o "${common_mount_options},compress=zstd,subvol=test/nix" \
        ${root_crypt_path} ${mount_point}/nix

    # create keyfile to unlock the root partition automatically after unlocking the boot partition
    dd bs=512 count=4 if=/dev/random of="${mount_point}/${ROOT_KEY_NAME}" iflag=fullblock
    chmod 600 "${mount_point}/${ROOT_KEY_NAME}"
    printf "\nAdding new keyfile to the 'root' partition, passphrase has to be entered:\n"
    cryptsetup luksAddKey "${root_partition}" "${mount_point}/${ROOT_KEY_NAME}"

    # create keyfile to unlock the boot partition when in the root partition
    # best working way for me currently :)
    dd bs=512 count=4 if=/dev/random of="${mount_point}/${BOOT_KEY_NAME}" iflag=fullblock
    chmod 600 "${mount_point}/${BOOT_KEY_NAME}"
    printf "\nAdding new keyfile to the 'boot' partition, passphrase has to be entered:\n"
    cryptsetup luksAddKey "${boot_partition}" "${mount_point}/${BOOT_KEY_NAME}"
}

main "$@"
