{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkOption types;
  fn = import ../lib {inherit lib;};
  cfg = config.modules;
in {
  imports = (fn.scanPaths ./.) ++ [./shell];

  options.modules = {
    hostName = mkOption {type = types.str;};
    domain = mkOption {
      type = types.str;
      default = "local";
    };
    defaultIF = mkOption {
      type = types.str;
      default = "ens192";
    };
    defaultIP = mkOption {
      type = types.str;
      default = "127.0.0.2";
    };
    defaultGW = mkOption {
      type = types.str;
      default = "127.0.0.254";
    };
    defaultMTU = mkOption {
      type = types.int;
      default = 1500;
    };
  };
  options.modules.defaults = {
    configRoot = mkOption {type = types.path;};
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Warsaw";
    };
    allowUnfree = mkOption {
      type = types.bool;
      default = true;
    };
    # lldpd = mkOption {
    #   type = types.bool;
    #   default = false;
    # };
    # machinePath = mkOption {type = types.str;};
    # libPath = mkOption {type = types.str;};
  };

  config = {
    time.timeZone = cfg.defaults.timeZone;
    documentation.man.enable = mkDefault true;
    networking.hostName = cfg.hostName;
    nixpkgs.config.allowUnfree = cfg.defaults.allowUnfree;
    nixpkgs.flake.setNixPath = false;
    nixpkgs.flake.setFlakeRegistry = false;
    nix.optimise.automatic = true;
    nix.settings = {
      max-jobs = 4;
      cores = 0;
      sandbox = mkDefault true;
      experimental-features = ["nix-command" "flakes"];
      require-sigs = false;
      trusted-users = ["root" "toor" "oom"];
    };
  };
}
