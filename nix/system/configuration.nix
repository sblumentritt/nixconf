{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = false;

    fonts = with pkgs; [
      lato
      source-code-pro
      source-han-code-jp
      roboto
      roboto-mono
      noto-fonts-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Lato" "Roboto"];
        sansSerif = ["Lato" "Roboto"];
        monospace = ["Source Code Pro" "Roboto Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
