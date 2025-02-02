{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.modules.desktop.hyprland;
in {
  # swaylock / pam
  # xdg.portals
  # programs.hyprland
  options.modules.desktop.hyprland.enable = mkEnableOption "Hyprland";
  config = mkIf cfg.enable {
    modules.security.polkit.enable = mkDefault true;
    modules.defaults.dbus.enable = mkDefault true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = false;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };

    programs = {
      hyprland = {
        enable = true;
        xwayland = {
          enable = true;
        };
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        # portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };

    services = {
      picom.enable = true;
    };

    security.pam.services.swaylock = {};
    security.pam.services.swaylock.fprintAuth = false;

    environment.systemPackages = with pkgs; [
      kitty
      kanshi
      waybar
      hyprshot
      hyprpaper
      swayidle
      swaylock-effects
      nwg-look
      brightnessctl
      wlogout
      wofi
      wl-clipboard
      libnotify
      mako
      adwaita-icon-theme
      xfce.thunar
      hypridle
      hyprlock
    ];
  };
}
