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

      authFile = mkOption {
        type = lib.types.path;
        default = config.age.secrets.prometheus.path;
        description = "Path to the auth file for the reverse proxy authentication.";
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

      caddy = mkIf cfg.reverseProxy.enable {
        enable = true;
        virtualHosts."portainer.${cfg.domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:9000
        '';
      };
    };
  };
}
