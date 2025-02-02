{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "mtr" cfg.apps) {
    programs.mtr.enable = true;
  }
