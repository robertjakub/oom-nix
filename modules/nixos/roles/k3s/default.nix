{
  fnlib,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types elem;
  defaults = config.modules.defaults;
in {
  imports = fnlib.scanPaths ./.;

  options.modules.roles.k3s = {
    enable = mkOption {
      type = types.bool;
      default = elem "k3s" defaults.roles;
    };
  };
}
