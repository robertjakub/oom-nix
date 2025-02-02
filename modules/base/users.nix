{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types listToAttrs;
  inherit (builtins) toPath;
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.modules.users;

  userOpts = {...}: {
    options = {
      name = mkOption {type = types.str;};
      description = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      home = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      sshkeys = mkOption {
        type = with types; listOf str;
        default = [];
      };
      id = mkOption {
        type = with types; nullOr int;
        default = null;
      };
      tags = mkOption {
        type = with types; listOf str;
        default = [];
      };
      shell = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      createHome = mkOption {
        type = with types; bool;
        default = true;
      };
      group = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };

  users = user: {
    inherit (user) name;
    value = let
      homePath =
        if isDarwin
        then "/Users"
        else "/home";
      home =
        if user.home != null
        then user.home
        else "${homePath}/${user.name}";
    in {
      inherit (user) name;
      description =
        if user.description != null
        then user.description
        else "Administrative user ${user.name}";
      home = toPath home;
      packages = [];
      openssh.authorizedKeys.keys = user.sshkeys;
    };
  };
in {
  options.modules.users = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    mutableUsers = mkOption {
      type = types.bool;
      default = true;
    };
    users = mkOption {
      type = types.listOf (types.submodule [userOpts]);
      default = [];
    };
    rootkeys = mkOption {
      type = with types; listOf str;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    users.users = listToAttrs (map users cfg.users);
  };
}
