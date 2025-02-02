{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.modules.defaults.sys-pkgs;
in {
  options.modules.defaults.sys-pkgs.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf cfg.enable {
    environment.etc."current-system-packages".text = let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;
  };
}
