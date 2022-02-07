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
}
