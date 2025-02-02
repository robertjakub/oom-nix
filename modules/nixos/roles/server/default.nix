{
  fnlib,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types elem mkIf;
  defaults = config.modules.defaults;
  cfg = config.modules.roles;
in {
  imports = fnlib.scanPaths ./.;

  options.modules.roles.server = {
    enable = mkOption {
      type = types.bool;
      default = elem "server" defaults.roles;
    };
  };
  config = mkIf cfg.server.enable {
    modules.wrappers.wrappers = ["fping"];
    modules.apps.apps = ["mtr" "wireshark"];
  };
}
