{ config, pkgs, services, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = false;

      # only use a TTY login prompt instead of the default 'lightdm'
      displayManager.startx.enable = true;

      windowManager.awesome = {
        enable = true;
        luaModules = [ pkgs.luajitPackages.vicious ];
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
}
