{ config, pkgs, ... }:

let
  boot_outer_uuid = "cf22708f-b675-4971-8884-9183ede13770";
  boot_inner_uuid = "e0a63f79-df23-469f-9d64-05983cb32512";

  root_outer_uuid = "9f5674cd-f11b-49c7-a975-ee981a0c56b5";
  root_inner_uuid = "f7cfbda7-2577-4d5f-9056-138b2e4209ed";

  disk_by_uuid = "/dev/disk/by-uuid";
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "boot.shell_on_fail" ];

    tmpOnTmpfs = true;
    # cleanTmpDir = true;

    loader = {
      grub = {
        version = 2;
        enable = true;

        efiSupport = true;
        enableCryptodisk = true;

        # needed as otherwise the legacy MBR is expected which is breaking the grub-install
        # with 'unusual large core.img' and 'btrfs doesn't support blocklists'
        device = "nodev";

        # extraConfig = ''GRUB_CMDLINE_LINUX="cryptdevice=LABEL=${root_crypt_name}"'';
        extraGrubInstallArgs = [ "--bootloader-id=grub-test" ];
      };

      efi.efiSysMountPoint = "/efi";
    };

    initrd = {
      supportedFilesystems = [ "btrfs" ];

      luks.reusePassphrases = true;
      luks.devices = {
        "cryptroot" = {
          device = "${disk_by_uuid}/${root_outer_uuid}";
          # keyFile = "${root_crypt_name}_keyfile.bin";
          fallbackToPassword = true;
          # should improve performance on SSDs, needs Linux >= 5.9
          bypassWorkqueues = true;
        };

        "cryptboot" = {
          device = "${disk_by_uuid}/${boot_outer_uuid}";
          # keyFile = "${boot_crypt_name}_keyfile.bin";
          fallbackToPassword = true;
          # should improve performance on SSDs, needs Linux >= 5.9
          bypassWorkqueues = true;
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "${disk_by_uuid}/${root_inner_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=test/root"
      ];
    };

    "/home" = {
      device = "${disk_by_uuid}/${root_inner_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=test/home"
      ];
    };

    "/var" = {
      device = "${disk_by_uuid}/${root_inner_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=test/var"
      ];
    };

    "/nix" = {
      device = "${disk_by_uuid}/${root_inner_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "space_cache"
        "commit=120"
        "subvol=test/nix"
      ];
    };

    "/boot" = {
      device = "${disk_by_uuid}/${boot_inner_uuid}";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=lzo"
        "space_cache"
        "commit=120"
      ];
      # depends = [ "/" ];
    };

    "/efi" = {
      device = "/dev/disk/by-label/efi";
      fsType = "vfat";
    };
  };
}
