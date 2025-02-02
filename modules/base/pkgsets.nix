{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types flatten forEach attrVals lists strings listToAttrs;
  fn = import ../lib {inherit lib;};

  pkgsets = fn.lst {
    p = toString ((fn.relativeToRoot) "./pkgsets");
    b = true;
  };
  pkgsetList = fn.makeOptionTypeList (toString ((fn.relativeToRoot) "./pkgsets"));
  pkgOption = pname: {
    name = pname;
    value = {
      pkgwrap = mkOption {
        type = with types; oneOf [package (listOf package)];
        default = fn.pkgFilter cfg.pkgsets."${pname}".pkgs;
        description = ''
          Package Wrapper for packages using a wrapper function (like python, emacs, haskell, ...)
        '';
      };
      pkgs = mkOption {
        type = types.unspecified;
        default = [];
        description = ''
          ${pname} package list.
        '';
      };
    };
  };
  cfg = config.modules.pkgsets;
in {
  options.modules.pkgsets = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    pkgs = mkOption {
      type = types.listOf (types.enum pkgsetList);
      default = ["base-smallx"];
      description = "The list of metapackages to be installed.";
    };
    pkgsets = listToAttrs (map pkgOption (lists.filter (v: !(strings.hasInfix "::" v)) pkgsetList));
  };
  imports = pkgsets;
  config = mkIf cfg.enable {
    environment.systemPackages =
      flatten
      (forEach
        (attrVals
          (lists.filter
            (v: !(strings.hasInfix "::" v))
            cfg.pkgs)
          cfg.pkgsets)
        (v: v.pkgwrap));
  };
}
