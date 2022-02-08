{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    font = {
      name = "Lato";
      size = 10;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita";
    };

    gtk3.extraConfig = {
      gtk-toolbar-style = "text";
      gtk-menu-images = false;
      gtk-button-images = false;
      gtk-primary-button-warps-slider = false;
      gtk-cursor-theme-size = false;
      gtk-toolbar-icon-size = "small";
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
      gtk-xft-antialias = true;
      gtk-xft-hinting = true;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = true;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}
