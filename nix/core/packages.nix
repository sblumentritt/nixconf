pkgs: with pkgs; [
    # from install.sh
    # base
    coreutils
    # network
    networkmanager
    iproute2
    iputils
    # filesystem utils
    dosfstools
    e2fsprogs
    sysfsutils
    btrfs-progs
    # compression
    bzip2
    gzip
    gnutar
    xz
    lzop
    # devel
    gcc11
    perl
    autoconf
    automake
    binutils
    fakeroot
    libtool
    gnumake
    gnupatch
    pkgconf
    # utils
    file
    findutils
    gawk
    gnugrep
    less
    procps
    gnused
    usbutils
    pciutils
    util-linux
    which
    sudo
    # misc
    man
    man-pages
    nano

    # from configure.sh
    # base
    openssh
    wget
    bash-completion
    ntfs3g
    libnotify
    rsync
    # base extras
    unzip
    zip
    pipewire
    pulsemixer
    udiskie
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
    # fonts
    lato
    source-code-pro
    source-han-code-jp
    roboto
    roboto-mono
    noto-fonts-emoji
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
    # xorg
    xorg.xset
    xorg.xrdb
    xorg.xprop
    xorg.xinit
    xorg.xhost
    xorg.xrandr
    xorg.xinput
    xorg.xmodmap
    xorg.xsetroot
    xorg.setxkbmap
    xorg.xorgserver
    # xcb
    xcb-util-cursor
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilimage
    xorg.xcbutilwm
    # other
    awesome
    luajitPackages.vicious
    xclip
    xsecurelock
    maim
    picom
  ]
