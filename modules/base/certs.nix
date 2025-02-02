{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types forEach;
  fn = import ../lib {inherit lib;};

  certDir = "${config.modules.defaults.configRoot}/defaults/certs";
  # FIXME
  # certDir = toString ((fn.relativeToDefaults) "./certs");
  certList = fn.makeOptionSuffixList {
    p = certDir;
    s = ".pem";
  };
  cfg = config.modules.cacerts;
in {
  options.modules.cacerts = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    certs = mkOption {
      type = types.listOf (types.enum certList);
      default = certList;
    };
  };
  config = mkIf cfg.enable {
    security.pki.certificateFiles =
      []
      ++ (forEach cfg.certs (x: /. + (certDir + "/" + toString x + ".pem")));
  };
}
