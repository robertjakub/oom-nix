{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.hm;
in {
  options.hm.ssh = {
    enable = mkEnableOption "home-manager/ssh";
  };
  config = mkIf (cfg.ssh.enable) {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      addKeysToAgent = "yes";
      compression = true;
      serverAliveInterval = 60;
      hashKnownHosts = false;
      # userKnownHostsFile = "~/.ssh/known_hosts.d/%k";
      # extraConfig = ''
      # '';
    };
  };
}
