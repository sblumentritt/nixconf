{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./network.nix
    ./fonts.nix
    ./users.nix
    ./xserver.nix
  ];

  nix = {
    extraOptions = "experimental-features = nix-command flakes";

    settings = {
      sandbox = true;
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_US/ISO-8859-1"
      "ja_JP.UTF-8/UTF-8"
      "ja_JP.EUC-JP/EUC-JP"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  sound.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    udev = {
      extraRules = ''
        SUBSYSTEM=="usb", DRIVER=="usb", ATTR{idProduct}=="4ee1", ATTR{idVendor}=="18d1", GROUP="developer", MODE="0660"
      '';
    };
  };

  # to have home-manager configure GTK the 'dconf' enable is required otherwise the service fails
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    # base
    openssh
    wget
    curl
    git
    bash-completion
    libnotify
    rsync
    # network
    networkmanager
    iproute2
    iputils
    # filesystem utils
    dosfstools
    e2fsprogs
    sysfsutils
    btrfs-progs
    ntfs3g
    # utils
    coreutils
    file
    findutils
    gawk
    gnugrep
    less
    procps
    gnused
    usbutils
    pciutils
    util-linux
    which
    sudo
    # misc
    man
    man-pages
    nano
  ];
}
