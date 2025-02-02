{lib, ...}: let
  inherit (lib) mkOption types;
  fn = import ../lib {inherit lib;};
  appsList = fn.makeOptionTypeList (toString ./apps);
  apps = fn.lst {
    p = toString ./apps;
    b = true;
  };
in {
  options.modules.apps = {
    apps = mkOption {
      type = types.listOf (types.enum appsList);
      default = [];
    };
  };
  imports = apps;
}
