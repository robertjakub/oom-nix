{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkOption types forEach lists strings listToAttrs;
  cfg = config.modules.wrappers;
  fn = import ../lib {inherit lib;};

  wrappersList = fn.makeOptionTypeList (toString ./wrappers);
  wrappers = fn.lst {
    p = toString ./wrappers;
    b = true;
  };
  wrapperOption = pname: {
    name = pname;
    value = {
      wrap = mkOption {
        type = with types; attrs;
        default = cfg.sets."${pname}".options;
      };
      options = mkOption {
        type = types.unspecified;
        default = [];
      };
    };
  };
in {
  options.modules.wrappers = {
    wrappers = mkOption {
      type = types.listOf (types.enum wrappersList);
      default = [];
    };
    sets = listToAttrs (map wrapperOption (lists.filter (v: !(strings.hasInfix "::" v)) wrappersList));
  };
  imports = wrappers;
  config = {
    assertions = [
      {
        assertion = isLinux;
        message = "wrappers: linux-only stanza!";
      }
    ];
    security.wrappers = listToAttrs (forEach cfg.wrappers (v: {
      name = v;
      value = cfg.sets.${v}.options;
    }));
  };
}
