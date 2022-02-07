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
        luaModules = [ pkgs.luajitPackages.vicious ];
      };

      libinput.enable = true;

      # xrandrHeads = [
      #   {
      #     output = "HDMI-A-1";
      #   }
      #   {
      #     output = "HDMI-A-0";
      #     primary = true;
      #   }
      # ];

      layout = "us,de";
      xkbModel = "pc105";
      xkbOptions = "grp:ctrls_toggle,caps:backspace,shift:both_capslock_cancel";
    };
  };
}
