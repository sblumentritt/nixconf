{ config, pkgs, services, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = false;

      # to avoid any strange problems
      # (https://github.com/NixOS/nixpkgs/issues/19629#issuecomment-368121456)
      exportConfiguration = true;

      # only use a TTY login prompt instead of the default 'lightdm'
      displayManager.startx.enable = true;

      windowManager.awesome = {
        enable = true;
        luaModules = [ pkgs.luaPackages.vicious ];
      };

      libinput.enable = true;

      xrandrHeads = [
        {
          output = "HDMI-A-1";
        }
        {
          output = "HDMI-A-0";
          primary = true;
        }
      ];

      layout = "us,de";
      xkbModel = "pc105";
      xkbOptions = "grp:ctrls_toggle,caps:backspace,shift:both_capslock_cancel";
    };
  };

  environment.systemPackages = with pkgs; [
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
  ];
}
