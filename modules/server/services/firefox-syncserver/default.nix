{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.firefox-syncserver;
in {
  options.services.firefox-syncserver = {
    customConf = mkEnableOption "Firefox sync server configuration";
  };

  config = mkIf cfg.customConf {
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
      mysql = {
        package = pkgs.mariadb;
      };

      firefox-syncserver = {
        secrets = "${pkgs.writeText "secrets" config.secrets.firefox-syncserver.privateKey}";

        singleNode = {
          url = "https://firefox.kosslan.dev";
          hostname = "localhost";
          enable = true;
          capacity = 5;
        };

        settings = {
          tokenserver.enabled = true;
          port = 5000;
        };

        database = {
          createLocally = true;
        };
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "firefox.kosslan.dev" = {
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
