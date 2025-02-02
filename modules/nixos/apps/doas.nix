{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "doas" cfg.apps) {
    security.doas.enable = true;
    security.doas.extraRules = [
      {
        users = (map (user: "${user.name} ") config.modules.users.users) ++ ["root"];
        keepEnv = true;
        persist = true;
      }
    ];
  }
