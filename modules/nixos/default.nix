{lib, ...}: let
  inherit (lib) mkDefault;
  fn = import ../lib {inherit lib;};
in {
  imports =
    [../base]
    ++ (fn.scanPaths ./.)
    ++ [./desktop]
    ++ [./packages];

  boot.tmp.cleanOnBoot = true;
  system.copySystemConfiguration = false;

  documentation.dev.enable = mkDefault true;
  documentation.nixos.enable = mkDefault false;

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";

  services.journald.extraConfig = ''
    Compress=yes
  '';

  # nix.configureBuildUsers = true;
  # ids.uids.nixbld = lib.mkForce 30000;
}
