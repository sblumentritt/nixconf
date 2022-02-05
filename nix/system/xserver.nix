{ config, pkgs, services, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = false;

      # only use a TTY login prompt instead of the default 'lightdm'
      displayManager.startx.enable = true;
    };
  };
}
