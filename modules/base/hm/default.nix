{
  config,
  lib,
  ...
}: let
  fn = import ../../lib {inherit lib;};
  cfg = config.modules;
in {
  imports = fn.scanPaths ./.;
  nixpkgs.config.allowUnfree = cfg.defaults.allowUnfree;
  home.stateVersion = "25.05";
}
