{ config, pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.bashInteractive;

    groups = {
      developer = {
        members = [ "sebastian" ];
      };
    };

    users = {
      sebastian = {
        isNormalUser = true;

        group = "developer";
        extraGroups = [ "wheel" "networkmanager" "users" "video" "audio" "input"];
      };
    };
  };
}
