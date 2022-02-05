{ config, pkgs, services, ... }:

{
  services = {
    gpg-agent = {
      enable = true;

      maxCacheTtl = 60480000;
      defaultCacheTtl = 60480000;

      pinentryFlavor = "qt";
    };

    mpd = {
      enable = true;
      package = pkgs.mpd-small;

      network = {
        listenAddress = "127.0.0.1";
        port = 7070;

        startWhenNeeded = true;
      };

      extraConfig = ''
        auto_update "no"
        auto_update_depth "0"

        follow_inside_symlinks "no"
        follow_outside_symlinks "no"
      '';
    };

    picom = {
      enable = true;

      vSync = true;
      extraOptions = ''
        wintypes:
        {
          tooltip = {
            fade = true;
            focus = true;
            full-shadow = false;
          };
        };
      '';
    };
  };
}
