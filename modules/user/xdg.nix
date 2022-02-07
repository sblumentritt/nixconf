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

    /*
    configFile = {
      # whole folder as symlink
      "alacritty".source = ../../config/alacritty;
      "bash".source = ../../config/bash;
      "fontconfig".source = ../../config/fontconfig;
      "git".source = ../../config/git;
      "gtk-3.0".source = ../../config/gtk-3.0;
      "imv".source = ../../config/imv;
      "mpv".source = ../../config/mpv;
      "nvim".source = ../../config/nvim;
      "qt5ct".source = ../../config/qt5ct;
      "tig".source = ../../config/tig;
      "tmux".source = ../../config/tmux;
      # only specific files as symlinks
      "mpd/mpd.conf".source = ../../config/mpd/mpd.conf;
      "ranger/rc.conf".source = ../../config/ranger/rc.conf;
      "ranger/rifle.conf".source = ../../config/ranger/rifle.conf;
      # X11 specific
      "awesome".source = ../../config/awesome;
      "picom".source = ../../config/picom;
      "X11".source = ../../config/X11;
    };
    */
  };
}
