{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "wireshark" cfg.apps) {
    environment.systemPackages = [pkgs.wireshark];
    homebrew.casks = ["wireshark-chmodbpf"];
  }
