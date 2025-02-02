{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.modules.desktop;
in {
  options.modules.desktop.sddm.enable = mkEnableOption "enable sddm";

  config = mkIf (cfg.sddm.enable) {
    environment.systemPackages = with pkgs; [
      (where-is-my-sddm-theme.override {
        variants = ["qt5"];
        themeConfig.General = {
          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundMode = "none";
          blurRadius = 75;
        };
      })
    ];
#    services.displayManager.defaultSession = "hyprland";
    services.displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme_qt5";
      wayland.enable = mkForce cfg.wayland.enable;
      wayland.compositor = "kwin";
    };
  };
}
