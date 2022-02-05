{ pkgs, servicves, ... }:

{
  services = {
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
  };
}
