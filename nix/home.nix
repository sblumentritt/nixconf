{ config, pkgs, ... }:

let
  packages = import ./core/packages.nix;
in
{
  # provide required information
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  # TODO: uncomment when switching to NixOS
  # home.packages = packages pkgs;

  imports = [
    ./core/xdg.nix
  ];

  # determines the home manager release that the configuration is compatible
  home.stateVersion = "22.05";

  # let home manager install and manage itself
  programs.home-manager.enable = true;
}
