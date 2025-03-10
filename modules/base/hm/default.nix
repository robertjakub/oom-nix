{lib, ...}: let
  fn = import ../../lib {inherit lib;};
in {
  imports = fn.scanPaths ./.;
  home.stateVersion = "25.05";
}
