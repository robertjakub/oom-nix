{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isAarch64;
  inherit (lib) mkIf;
  cfg = config.modules.roles;
in {
  config = mkIf (isAarch64 && cfg.k3s.enable) {
    boot.kernelParams = [
      "cgroup_memory=1"
      "cgroup_enable=cpuset"
      "cgroup_enable=memory"
    ];
  };
}
