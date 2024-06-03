{
  lib,
  config,
  ...
}: let
  cfg = config.services.firefox-syncserver;
in {
  options.services.firefox-syncserver = {
    customConf = lib.mkEnableOption "Firefox sync server configuration";
  };

  config = lib.mkIf cfg.customConf {
    networking = {
      firewall = {
        allowedTCPPorts = [80 443];
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      firefox-syncserver = {
        singleNode = {
          enable = true;
          capacity = 5;
        };

        database = {
          createLocally = true;
        };
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "sync.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:5000";
                extraConfig = ''
                  proxy_set_header X-Forwarded-Host $host;
                  proxy_set_header X-Forwarded-Server $host;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Real-IP $remote_addr;
                '';
              };
            };
          };
        };
      };
    };
  };
}
