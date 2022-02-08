{ config, pkgs, ... }:

{
  # provide required information
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  imports = [
    ./packages.nix
    ./xdg.nix
    ./gtk.nix
    ./services.nix
  ];

  # determines the home manager release that the configuration is compatible
  home.stateVersion = "22.05";

  # let home manager install and manage itself
  programs.home-manager.enable = true;
}
