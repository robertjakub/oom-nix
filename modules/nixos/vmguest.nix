{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.modules.defaults;
in {
  options.modules.defaults.vmguest = mkOption {
    type = types.bool;
    default = false;
  };
  config = mkIf cfg.vmguest {
    virtualisation.vmware.guest.enable = cfg.vmguest;
  };
}
