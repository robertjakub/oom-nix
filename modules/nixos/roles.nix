{lib, ...}: let
  inherit (lib) mkOption types;
  roles = ["k3s" "server"];
in {
  imports = [./roles/k3s ./roles/server];
  options.modules.defaults.roles = mkOption {
    type = types.listOf (types.enum roles);
    default = [];
  };
}
