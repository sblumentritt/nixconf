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
      # whole folder as symlink
      "alacritty".source = ../../config/alacritty;
      "bash".source = ../../config/bash;
      "git".source = ../../config/git;
      "imv".source = ../../config/imv;
      "mpv".source = ../../config/mpv;
      "nvim".source = ../../config/nvim;
      "qt5ct".source = ../../config/qt5ct;
      "tig".source = ../../config/tig;
      "tmux".source = ../../config/tmux;
      # only specific files as symlinks
      "ranger/rc.conf".source = ../../config/ranger/rc.conf;
      "ranger/rifle.conf".source = ../../config/ranger/rifle.conf;
      # X11 specific
      "awesome".source = ../../config/awesome;
      "X11".source = ../../config/X11;
    };
  };

  # not really XDG specific but is fits here the best
  home.file = {
    ".profile".source = ../../config/.profile;
    ".bashrc".source = ../../config/.bashrc
  };
}
