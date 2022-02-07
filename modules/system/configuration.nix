{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./xserver.nix
  ];

  nix = {
    useSandbox = true;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions = "experimental-features = nix-command flakes";

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

  networking = {
    hostName = "test";
    networkmanager.enable = true;
  };

  users = {
    defaultUserShell = pkgs.bashInteractive;

    groups = {
      developer = {
        members = [ "sebastian" ];
      };
    };

    users = {
      sebastian = {
        isNormalUser = true;

        group = "developer";
        extraGroups = [ "wheel" "networkmanager" "users" "video" "audio" "input"];
      };
    };
  };

  fonts = {
    enableDefaultFonts = false;

    fonts = with pkgs; [
      lato
      source-code-pro
      source-han-code-jp
      roboto
      roboto-mono
      noto-fonts-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Lato" "Roboto" ];
        sansSerif = [ "Lato" "Roboto" ];
        monospace = [ "Source Code Pro" "Roboto Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    coreutils
    nano
    wget
    curl
    git
  ];
}
