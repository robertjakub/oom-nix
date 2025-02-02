{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf listToAttrs elem mkDefault;
  cfg = config.modules.users;

  users = user: {
    inherit (user) name;
    value = mkIf (elem "hm" user.tags) {
      home.enableNixpkgsReleaseCheck = false;
      hm.zsh.enable = mkDefault true;
      hm.ssh.enable = mkDefault true;
      hm.direnv.enable = mkDefault true;
      hm.tmux.enable = mkDefault true;
    };
  };
in {
  config = mkIf cfg.enable {
    home-manager.backupFileExtension = "pre-hm";
    home-manager.users = listToAttrs (map users cfg.users);
  };
}
