{ config, pkgs, ... }:

{
  networking = {
    hostName = "test";
    extraHosts = ''
      # The following lines are desirable for IPv6 capable hosts
      ff02::1         ip6-allnodes
      ff02::2         ip6-allrouters
    '';

    networkmanager.enable = true;
  };
}
