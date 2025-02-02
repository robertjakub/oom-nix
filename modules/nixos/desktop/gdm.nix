{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types mkForce;
  cfg = config.modules.desktop;
in {
  options.modules.desktop.gnome = {
    gdm = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.gnome.enable && cfg.gnome.gdm) {
    # services.xserver.enable = true;
    # services.xserver.displayManager.defaultSession = mkIf (!cfg.gdm) null;
    services.xserver.displayManager.gdm = {
      enable = true;
      autoSuspend = false;
      wayland = mkForce cfg.wayland.enable;
    };
  };
}
