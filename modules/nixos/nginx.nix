{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types listToAttrs replaceStrings attrNames recursiveUpdate;
  inherit (builtins) readDir toPath;
  cfg = config.modules.nginx;

  vHostConfigs = listToAttrs (map
    (name: {
      name = replaceStrings [".nix"] [""] name;
      value = import (./. + (toPath "/nginx-vHosts/${name}")) {inherit config lib pkgs;};
    })
    (attrNames (readDir ./nginx-vHosts)));

  mkVHost = vHost: {
    name = vHost.domain;
    value = let
      proxyPass =
        if (vHost.proxy != null)
        then {locations."/".proxyPass = vHost.proxy;}
        else {};
      redirectURL =
        if (vHost.redirect != null)
        then {locations."/".extraConfig = "return 301 ${vHost.redirect}$request_uri;";}
        else {};
      attrs = recursiveUpdate vHostConfigs."${vHost.service}" (proxyPass // redirectURL);
    in
      {
        enableACME = vHost.acme;
        addSSL =
          if (vHost.ssl && vHost.plain)
          then true
          else false;
        forceSSL =
          if (vHost.ssl && !vHost.plain)
          then true
          else false;
        acmeRoot = "/var/lib/acme/acme-challenge";
        root = vHost.root;
        serverAliases = vHost.aliases;
        listenAddresses = vHost.listenAddresses;
      }
      // attrs;
  };

  vHostsOpts = {config, ...}: {
    options = {
      service = mkOption {type = types.str;};
      domain = mkOption {type = types.str;};
      aliases = mkOption {
        type = with types; listOf str;
        default = [];
      };
      proxy = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      ssl = mkOption {
        type = types.bool;
        default = cfg.defaults.ssl;
        description = "SSL port";
      };
      acme = mkOption {
        type = types.bool;
        default = cfg.defaults.acme;
        description = "ACME support";
      };
      plain = mkOption {
        type = types.bool;
        default = cfg.defaults.plain;
        description = "add non-SSL port";
      };
      root = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "webroot location";
      };
      redirect = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "vHost redirect url";
      };
      listenAddresses = mkOption {
        type = with types; listOf str;
        default = [];
      };
    };
  };
in {
  options.modules.nginx = {
    enable = mkEnableOption "nginx";
    openFirewall = mkEnableOption "nginx: open default ports";
    vHosts = mkOption {
      type = types.listOf (types.submodule [vHostsOpts]);
      default = [];
    };
    defaults.acme = mkOption {
      type = types.bool;
      default = config.modules.defaults.acme.enable;
      description = "enable default ACME support";
    };
    defaults.ssl = mkEnableOption "enable default ssl";
    defaults.plain = mkEnableOption "enable default non-ssl support";
    defaults.listenAddresses = mkOption {
      type = with types; listOf str;
      default = ["0.0.0.0"]; # TODO: IPv6
    };
  };
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      sslCiphers = "ALL:!aNULL:EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
      sslProtocols = "TLSv1.3 TLSv1.2"; # SSL

      commonHttpConfig = ''
        map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
      '';
      defaultListenAddresses = cfg.defaults.listenAddresses;
      virtualHosts = listToAttrs (map mkVHost cfg.vHosts);
    };

    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall) [80 443];
  };
}
