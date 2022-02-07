{ config, pkgs, ... }:

let
  root_crypt_name = "cryptroot";
  boot_crypt_name = "cryptboot";

  disk_path_prefix = "/dev/disk/by-label";
in
{
  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      grub = {
        version = 2;
        enable = true;

        efiSupport = true;
        enableCryptodisk = true;

        # needed as otherwise the legacy MBR is expected which is breaking the grub-install
        # with 'unusual large core.img' and 'btrfs doesn't support blocklists'
        device = "nodev";

        extraGrubInstallArgs = [ "--bootloader-id=test" ];
      };

      efi.efiSysMountPoint = "/efi";
    };

    initrd = {
      supportedFilesystems = [ "btrfs" ];

      luks.devices = {
        "${root_crypt_name}" = {
          device = "${disk_path_prefix}/root";
          keyFile = "${root_crypt_name}_keyfile.bin";
          fallbackToPassword = true;
          # should improve performance on SSDs, needs Linux >= 5.9
          bypassWorkqueues = true;
        };

        "${boot_crypt_name}" = {
          device = "${disk_path_prefix}/boot";
          keyFile = "${boot_crypt_name}_keyfile.bin";
          fallbackToPassword = true;
          # should improve performance on SSDs, needs Linux >= 5.9
          bypassWorkqueues = true;
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${root_crypt_name}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=/test/root"
      ];
    };

    "/home" = {
      device = "/dev/mapper/${root_crypt_name}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=/test/home"
      ];
    };

    "/var" = {
      device = "/dev/mapper/${root_crypt_name}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=/test/var"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/${root_crypt_name}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=/test/nix"
      ];
    };

    "/boot" = {
      device = "/dev/mapper/${boot_crypt_name}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=lzo"
        "space_cache"
        "commit=120"
      ];
      depends = [ "/" ];
    };

    "/efi" = {
      device = "${disk_path_prefix}/efi";
      fsType = "vfat";
    };
  };
}
