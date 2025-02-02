{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.modules.roles;
in {
  config = mkIf cfg.k3s.enable {
    networking.firewall.allowedTCPPorts = [
      6443 # k3s: kubernetes API (TCP)
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
      10250 # k3s: Metrics Server (TCP)
    ];
    networking.firewall.allowedUDPPorts = [
      8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];
  };
}
