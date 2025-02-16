{lib, ...}: let
  fn = import ../lib {inherit lib;};
in {
  imports = [../base] ++ (fn.scanPaths ./.);
  config = {
    # services.activate-system.enable = true;
    # services.nix-daemon.enable = true;
    system.stateVersion = 6;
  };
}
