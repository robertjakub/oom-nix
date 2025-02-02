{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.services.openssh.openFirewall {
    networking = {
      firewall = {
        allowedTCPPorts = [22];
      };
    };
  };
}
