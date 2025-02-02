{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.modules.roles;
in {
  config = mkIf cfg.server.enable {
    modules.services.services = ["avahi"];

    systemd.network.enable = true;
    systemd.network.networks."80-container-ve" = {
      matchConfig = {
        Name = "ve-*";
        Kind = "veth";
      };
      linkConfig.Unmanaged = true;
    };

    networking.useDHCP = false;
  };
}
