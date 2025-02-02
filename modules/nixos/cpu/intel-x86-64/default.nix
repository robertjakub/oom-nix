{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault;
in {
  hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
}
