{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.firefox-syncserver;
in {
  options.services.firefox-syncserver = {
    defaults = {
      enable = mkEnableOption "Firefox sync server configuration";
    };

    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy for Firefox sync server";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [80 443];
      };
    };

    security.acme = mkIf cfg.reverseProxy.enable {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      mysql = mkIf cfg.defaults.enable {
        package = pkgs.mariadb;
      };

      firefox-syncserver = mkIf cfg.defaults.enable {
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

      nginx = mkIf cfg.reverseProxy.enable {
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
