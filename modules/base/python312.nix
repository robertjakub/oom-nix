{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  # FIXME
  # click-params = pkgs.callPackage ((fn.relativeToRoot) "pkgs/click-params") {pythonPackages = pkgs.python312Packages;};
  python-deps = ps:
    with ps;
      [ovh lxml xattr netaddr setuptools click colorama click-help-colors validators pyserial]
      ++ [];
in {
  options.modules.python312 = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf config.modules.python312 {
    environment.systemPackages = with pkgs; [
      (python312.withPackages python-deps)
    ];
  };
}
