{
  config,
  lib,
  ...
}:
with lib;
  {
    vHost =
      if config.services.uptime-kuma.enable
      then {
        extraConfig = ''
          location / {
            proxy_pass http://${config.services.uptime-kuma.settings.HOST}:${toString config.services.uptime-kuma.settings.PORT};
            proxy_set_header Host $host;
            proxy_set_header REMOTE_ADDR $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          }
        '';
        #      extraConfig = ''
        #          client_max_body_size 0;
        #          proxy_max_temp_file_size 0;
        #          proxy_redirect off;
        #          proxy_read_timeout 120;
        #        }
        #      '';
      }
      else {};
  }
  .vHost
