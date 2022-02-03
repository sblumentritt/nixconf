{ config, pkgs, ... }:

let
  packages = import ./packages.nix;
in
{
  # provide required information
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  home.packages = packages pkgs;

  # determines the home manager release that the configuration is compatible
  home.stateVersion = "22.05";

  # let home manager install and manage itself
  programs.home-manager.enable = true;
}
