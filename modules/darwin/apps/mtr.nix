{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "mtr" cfg.apps) {
    environment.systemPackages = [pkgs.mtr];
  }
