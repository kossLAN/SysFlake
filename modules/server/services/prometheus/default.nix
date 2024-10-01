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

      tailnet = mkOption {
        type = lib.types.bool;
        default = false;
      };

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

    deployment.tailnetSubdomains = mkIf cfg.reverseProxy.tailnet ["prometheus"];

    services = mkIf cfg.defaults.enable {
      prometheus = {
        port = 3255;
        globalConfig.scrape_interval = "10s";
        exporters = {
          node = {
            enable = true;
            enabledCollectors = ["systemd"];
            extraFlags = ["--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi"];
            port = 3256;
          };
        };

        scrapeConfigs = [
          {
            job_name = "cerebrite";
            static_configs = [
              {
                targets = [
                  "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
                ];
              }
            ];
          }
        ];
      };

      caddy = mkIf cfg.reverseProxy.enable {
        enable = true;
        virtualHosts."http://prometheus.${cfg.reverseProxy.domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:3255
        '';
      };
    };
  };
}
