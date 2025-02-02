{
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  config.modules.wrappers.sets.dumpcap.options = {
    owner = "root";
    group = "wireshark";
    permissions = mkForce "u+xs,g+x";
    source = mkForce "${config.programs.wireshark.package}/bin/dumpcap";
  };
}
