{ config, pkgs, ... }:

{
  # provide required information
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  home.packages = with pkgs; [
    # llvm
    llvmPackages_13.llvm
    clang_13
    clang-tools
    lld_13
    lldb
    # development
    git
    git-lfs
    tk
    cmake
    cppcheck
    gdb
    ninja
    meld
    sumneko-lua-language-server
    # Qt/QML development
    qtcreator
    # music
    mpd
    mpc-cli
    # commandline
    alacritty
    tmux
    neovim
    ranger
    tig
    htop
    fzf
    ripgrep
    fd
    exa
    jq
    codespell
    # style
    libsForQt5.qt5ct
    papirus-icon-theme
    # graphics & design
    scribusUnstable
    krita
    gmic-qt-krita
    inkscape
    # browser
    firefox
    # other
    transmission-qt
    mpv
    imv
    mupdf
    android-file-transfer
  ];

  # determines the home manager release that the configuration is compatible
  home.stateVersion = "22.05";

  # let home manager install and manage itself
  programs.home-manager.enable = true;
}
