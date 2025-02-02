{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "neovim" cfg.apps) {
    environment.systemPackages = [pkgs.neovim];
  }
