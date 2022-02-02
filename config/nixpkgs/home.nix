{ config, pkgs, ... }:

{
  # provide required information
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  home.packages = [
    # llvm
    pkgs.llvmPackages_13.llvm
    pkgs.clang_13
    pkgs.clang-tools
    pkgs.lld_13
    pkgs.lldb
    # development
    pkgs.git
    pkgs.git-lfs
    pkgs.tk
    pkgs.cmake
    pkgs.cppcheck
    pkgs.gdb
    pkgs.ninja
    pkgs.meld
    pkgs.sumneko-lua-language-server
    # Qt/QML development
    pkgs.qtcreator
    # music
    pkgs.mpd
    pkgs.mpc-cli
    # commandline
    pkgs.alacritty
    pkgs.tmux
    pkgs.neovim
    pkgs.ranger
    pkgs.tig
    pkgs.htop
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.exa
    pkgs.jq
    pkgs.codespell
    # style
    pkgs.libsForQt5.qt5ct
    pkgs.papirus-icon-theme
    # graphics & design
    pkgs.scribusUnstable
    pkgs.krita
    pkgs.gmic-qt-krita
    pkgs.inkscape
    # browser
    pkgs.firefox
    # other
    pkgs.transmission-qt
    pkgs.mpv
    pkgs.imv
    pkgs.mupdf
    pkgs.android-file-transfer
  ];

  # determines the home manager release that the configuration is compatible
  home.stateVersion = "22.05";

  # let home manager install and manage itself
  programs.home-manager.enable = true;
}
