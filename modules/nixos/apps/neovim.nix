{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.modules.apps;
in
  mkIf (elem "neovim" cfg.apps) {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  }
