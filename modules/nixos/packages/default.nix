{lib, ...}: let
  fn = import ../../lib {inherit lib;};
in {
  imports = fn.scanPaths ./.;
}
