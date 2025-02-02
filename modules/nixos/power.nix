{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  powerManagement = {
    enable =
      if config.boot.isContainer
      then false
      else mkDefault true;
    cpuFreqGovernor = mkDefault "ondemand";
  };
}
