#!/usr/bin/env sh

ROOT_CRYPT_NAME="cryptroot"

main() {
    # script should be run as root
    if [ "$(id -u)" -ne 0 ]; then
        printf "Please run as root!\n" 1>&2
        exit 1
    fi

    # show list of block devices for easier selection
    lsblk -a -o NAME,SIZE,MOUNTPOINT

    printf "\nOn which drive name do you want to install the system? "
    read -r drive_name

    if [ -z "${drive_name}" ]; then
        printf "\nDrive name needs to be set and can not be empty!\n" 1>&2
        exit 1
    fi

    local drive_path="/dev/${drive_name}"
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

    local efi_partition=""
    local boot_partition=""
    local root_partition=""
    local root_crypt_path="/dev/mapper/${ROOT_CRYPT_NAME}"

    lsblk "${drive_path}"
    # as it is unpredictable how the drives are named (sdxY,mmcblkxpY,nvme0nxpY)
    # -> https://wiki.archlinux.org/index.php/Device_file
    # it is much safer to just ask the user for the partition paths
    printf "Please enter the 'efi' partition name: "
    read -r efi_partition_name
    efi_partition="/dev/${efi_partition_name}"

    printf "Please enter the 'boot' partition name: "
    read -r boot_partition_name
    boot_partition="/dev/${boot_partition_name}"

    printf "Please enter the 'root' partition name: "
    read -r root_partition_name
    root_partition="/dev/${root_partition_name}"

    # encrypt the root partition with LUKS2
    printf "\nSetup encryption for the 'root' partition:\n"
    cryptsetup luksFormat --type luks2 \
        --label "luksroot" --uuid 9f5674cd-f11b-49c7-a975-ee981a0c56b5 "${root_partition}"

    # open the encrypted partition which will be mapped to /dev/mapper/<name>
    printf "\nUnlocking 'root' partition, passphrase has to be entered:\n"
    cryptsetup open "${root_partition}" "${ROOT_CRYPT_NAME}"

    # format partitions
    mkfs.fat -F32 -n "efi" -i 8F7AD91E "${efi_partition}"
    mkfs.btrfs -f -L "boot" -U e0a63f79-df23-469f-9d64-05983cb32512 "${boot_partition}"
    mkfs.btrfs -f -L "root" -U f7cfbda7-2577-4d5f-9056-138b2e4209ed "${root_crypt_path}"

    # create subvolumes
    mount -t btrfs ${root_crypt_path} ${mount_point}
    (
        cd "${mount_point}" || exit

        btrfs subvolume create "system"
        btrfs subvolume create "system/root"
        btrfs subvolume create "system/home"
        btrfs subvolume create "system/var"
        btrfs subvolume create "system/nix"
    )

    umount -R ${mount_point}

    # mount subvolumes on correct positions with the correct options
    local common_mount_options="noatime,space_cache,commit=120"

    mount -o "${common_mount_options},compress=zstd,subvol=system/root" \
        ${root_crypt_path} ${mount_point}

    # define variables to create folders needed for the mount
    local IFS=','
    local wanted_folder="efi,boot,home,var,nix"

    for folder in $wanted_folder; do
        mkdir -p "${mount_point}/${folder}"
    done

    mount ${efi_partition} ${mount_point}/efi
    mount -o "${common_mount_options},compress=lzo" ${boot_partition} ${mount_point}/boot

    mount -o "${common_mount_options},compress=zstd,subvol=system/home" \
        ${root_crypt_path} ${mount_point}/home

    mount -o "${common_mount_options},compress=zstd,subvol=system/var" \
        ${root_crypt_path} ${mount_point}/var

    mount -o "${common_mount_options},compress=zstd,subvol=system/nix" \
        ${root_crypt_path} ${mount_point}/nix
}

main "$@"
