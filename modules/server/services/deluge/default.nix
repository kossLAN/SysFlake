{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.deluge;
in {
  options.services.deluge = {
    container = {
      enable = mkEnableOption "Deluge container setup";

      authFile = mkOption {
        type = lib.types.path;
        default = "/etc/deluge/auth";
      };

      listenInterface = mkOption {
        type = lib.types.str;
        default = "";
      };
    };

    web.reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy for deluge webui";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = {
    networking = mkIf cfg.web.reverseProxy.enable {
      firewall.allowedTCPPorts = [80 443];
    };

    security.acme = mkIf cfg.web.reverseProxy.enable {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    systemd.tmpfiles.rules = mkIf cfg.container.enable [
      "d /srv/torrents 1775 8000 8000"
    ];

    containers.deluge = mkIf cfg.container.enable {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.13";
      config = {
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [8112 58846];
          };

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services = {
          resolved.enable = true;

          deluge = {
            enable = true;
            declarative = true;
            authFile = pkgs.writeText "authFile" config.secrets.deluge.privateKey; #cfg.container.authFile;
            group = "root";
            user = "root";

            web = {
              enable = true;
              port = 8112;
            };

            config = {
              download_location = "/srv/torrents/";
              max_upload_speed = "38000";
              share_ratio_limit = "2.0";
              seed_time_limit = "25000";
              allow_remote = true;
              daemon_port = 58846;
              listen_ports = [43567 36060]; # Ports from AirVPN
              enabled_plugins = ["Label"];
            };
          };
        };

        system.stateVersion = "23.11";
      };

      bindMounts = {
        "/srv/torrents" = {
          isReadOnly = false;
          hostPath = "/srv/torrents";
        };
      };
    };

    services = mkIf cfg.web.reverseProxy.enable {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts."deluge.${cfg.web.reverseProxy.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://192.168.100.13:${builtins.toString cfg.web.port}";
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
}
