{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
  pkgShark =
    if config.services.xserver.enable
    then pkgs.wireshark-qt
    else pkgs.tshark;
in
  mkIf (elem "wireshark" cfg.apps) {
    programs.wireshark = {
      enable = true;
      package = pkgShark;
    };
    users.groups.wireshark.gid = 500;
    modules.wrappers.wrappers = ["dumpcap"];
  }
