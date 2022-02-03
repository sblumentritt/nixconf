{ config, pkgs, ... }:

{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "$HOME/";
      templates = "$HOME/";
      publicShare = "$HOME/";

      music = "$HOME/music";
      videos = "$HOME/videos";
      pictures = "$HOME/pictures";
      download = "$HOME/downloads";
      documents = "$HOME/documents";
    };

    configFile = {
      # "hm_test".source = ../hm_test;
    };
  };
}
