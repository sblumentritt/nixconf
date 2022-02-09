{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # base devel
    # can not be installed when clang is also used because of 'c++' conflict
    # gcc11
    perl
    autoconf
    automake
    # can not be installed because of 'ld' conflict
    # binutils
    fakeroot
    libtool
    gnumake
    gnupatch
    pkgconf
    # base extras
    pipewire
    pulsemixer
    udiskie
    # compression
    bzip2
    gzip
    gnutar
    xz
    lzop
    unzip
    zip
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

    # X11 specific packages
    xclip
    xsecurelock
    maim
    picom
  ];
}
