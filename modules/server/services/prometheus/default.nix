{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.prometheus;
in {
  options.services.prometheus = {
    customConf = lib.mkEnableOption "Prometheus custom configuration";
  };

  config = lib.mkIf cfg.customConf {
    services = {
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

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = {
          "prometheus.kosslan.dev" = {
            basicAuth = {koss = config.secrets.prometheus.privateKey;};
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:3255/";
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
