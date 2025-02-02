{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.modules.desktop;
in {
  options.modules.desktop.opengl.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf (cfg.enable && cfg.opengl.enable) {
    hardware.graphics.enable = true;
    # hardware.graphics.enable32Bit = true;
  };
}
