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
      "alacritty".source = ../alacritty;
      "bash".source = ../bash;
      "fontconfig".source = ../fontconfig;
      "git".source = ../git;
      "gtk-3.0".source = ../gtk-3.0;
      "imv".source = ../imv;
      "mpv".source = ../mpv;
      "nvim".source = ../nvim;
      "qt5ct".source = ../qt5ct;
      "tig".source = ../tig;
      "tmux".source = ../tmux;
      # only specific files as symlinks
      "mpd/mpd.conf".source = ../mpd/mpd.conf;
      "ranger/rc.conf".source = ../ranger/rc.conf;
      "ranger/rifle.conf".source = ../ranger/rifle.conf;
      # X11 specific
      "awesome".source = ../awesome;
      "picom".source = ../picom;
      "X11".source = ../X11;
    };
    */
  };
}
