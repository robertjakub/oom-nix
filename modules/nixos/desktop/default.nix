{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop;
  fn = import ../../lib {inherit lib;};
in {
  options.modules.desktop = {
    enable = mkEnableOption "x11/desktop/graphics";
    wayland.enable = mkEnableOption "wayland";
  };

  imports = fn.scanPaths ./.;

  config = mkIf cfg.enable {
    services.xserver = {
      enable = cfg.enable;
      xkb.layout = "us, pl";
    };
    programs.xwayland.enable = cfg.wayland.enable;

    environment.systemPackages = with pkgs; [
      gsettings-desktop-schemas
    ];
  };
}
