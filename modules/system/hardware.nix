{ config, pkgs, ... }:

let
  efi_uuid = "8F7A-D91E";
  boot_uuid = "e0a63f79-df23-469f-9d64-05983cb32512";
  root_uuid = "f7cfbda7-2577-4d5f-9056-138b2e4209ed";
  luksroot_uuid = "9f5674cd-f11b-49c7-a975-ee981a0c56b5";

  disk_by_uuid = "/dev/disk/by-uuid";
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "boot.shell_on_fail" ];

    tmpOnTmpfs = true;

    loader = {
      grub = {
        version = 2;
        enable = true;

        efiSupport = true;
        enableCryptodisk = true;

        # needed as otherwise the legacy MBR is expected which is breaking the grub-install
        # with 'unusual large core.img' and 'btrfs doesn't support blocklists'
        device = "nodev";

        extraGrubInstallArgs = [ "--bootloader-id=grub-test" ];
      };

      efi.efiSysMountPoint = "/efi";
    };

    initrd = {
      supportedFilesystems = [ "btrfs" ];

      luks.devices = {
        "cryptroot" = {
          device = "${disk_by_uuid}/${luksroot_uuid}";
          # should improve performance on SSDs, needs Linux >= 5.9
          bypassWorkqueues = true;
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "${disk_by_uuid}/${root_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=system/root"
      ];
    };

    "/home" = {
      device = "${disk_by_uuid}/${root_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=system/home"
      ];
    };

    "/var" = {
      device = "${disk_by_uuid}/${root_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=system/var"
      ];
    };

    "/nix" = {
      device = "${disk_by_uuid}/${root_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=system/nix"
      ];
    };

    "/boot" = {
      device = "${disk_by_uuid}/${boot_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=lzo"
        "space_cache"
        "commit=120"
      ];
    };

    "/efi" = {
      device = "${disk_by_uuid}/${efi_uuid}";
      fsType = "vfat";
    };
  };
}
