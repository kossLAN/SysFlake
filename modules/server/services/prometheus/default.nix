{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.prometheus;
in {
  options.services.prometheus = {
    defaults.enable = mkEnableOption "Prometheus opinionated defaults.";
    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.enable {
    security.acme = mkIf cfg.reverseProxy.enable {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.reverseProxy.enable [80 443];

    services = mkIf cfg.defaults.enable {
      prometheus = {
        port = 3255;
        exporters = {
          node = {
            enable = true;
            enabledCollectors = ["systemd"];
            port = 3256;
          };
        };

        scrapeConfigs = [
          {
            job_name = "cerebrite";
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
              }
            ];
          }
        ];
      };

      nginx = mkIf cfg.reverseProxy.enable {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = {
          "prometheus.${cfg.reverseProxy.domain}" = {
            basicAuth = {koss = config.secrets.prometheus.privateKey;};
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_ssl_server_name on;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };
        };
      };
    };
  };
}
