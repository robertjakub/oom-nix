{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "vmware" cfg.apps) {
    virtualisation.vmware.host.enable = true;
    virtualisation.vmware.host.extraConfig = ''
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDevices = "TRUE"
    '';
  }
