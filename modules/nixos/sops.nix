{
  config,
  lib,
  sops-nix,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (builtins) filter elem;
  inherit (lib) listToAttrs;
  cfg = config.modules.defaults.sops;
in {
  options.modules.defaults.sops = {
    enable = mkEnableOption "defaults: sops";
    defaultSopsFile = mkOption {
      type = types.path;
    };
  };
  imports = [sops-nix.nixosModules.sops];
  config = mkIf (cfg.enable) {
    sops = {
      defaultSopsFile = cfg.defaultSopsFile;
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      secrets = listToAttrs (map
        (user: {
          name = (user: "users/${user.name}/password") user;
          value = {neededForUsers = true;};
        })
        (filter (s: (elem "sops" s.tags)) config.modules.users.users));
    };
  };
}
