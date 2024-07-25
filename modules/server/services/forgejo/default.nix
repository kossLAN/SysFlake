{
  lib,
  config,
  pkgs,
  stateVersion,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.forgejo;
in {
  options.services.forgejo = {
    container.enable = mkEnableOption "Forgjo custom configuration";
    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.container.enable {
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    networking = {
      firewall = {
        allowedTCPPorts = [80 443 22];
        extraCommands = ''
          iptables -t nat -A PREROUTING -i eno1 -p tcp --dport 22 -j DNAT --to-destination 192.168.100.12:2000
          iptables -t nat -A POSTROUTING -d 192.168.100.12 -p tcp --dport 2000 -j MASQUERADE
        '';
      };

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "eno1";
        forwardPorts = [
          {
            destination = "192.168.100.12:2000";
            proto = "tcp";
            sourcePort = 22;
          }
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/forgejo 0700 8001 8001"
    ];

    containers.forgejo = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.12";

      config = {
        environment.systemPackages = [pkgs.forgejo];

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [4000 2000];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        users = {
          users.forgejo.uid = 8001;
          groups.forgejo.gid = 8001;
        };

        services = {
          resolved.enable = true;

          forgejo = {
            enable = true;
            settings = {
              server = {
                HTTP_ADDR = "192.168.100.12";
                HTTP_PORT = 4000;
                DOMAIN = "git.kossland.dev";
                ROOT_URL = "https://git.kosslan.dev";

                START_SSH_SERVER = true;
                BUILTIN_SSH_SERVER_USER = "git";
                SSH_LISTEN_HOST = "192.168.100.12";
                SSH_LISTEN_PORT = 2000;
              };

              service.DISABLE_REGISTRATION = true;
              database.SQLITE_JOURNAL_MODE = "WAL";

              cache = {
                ADAPTER = "twoqueue";
                HOST = ''{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}'';
              };

              DEFAULT.APP_NAME = "Forgejo";
              repository.DEFAULT_BRANCH = "master";
              ui.DEFAULT_THEME = "forgejo-dark";

              "ui.meta" = {
                AUTHOR = "Forgejo";
                DESCRIPTION = "kossLAN's self-hosted git instance";
              };

              metrics.ENABLED = true;
            };
          };
        };

        system.stateVersion = stateVersion;
      };

      bindMounts = {
        "/var/lib/forgejo" = {
          isReadOnly = false;
          hostPath = "/var/lib/forgejo";
        };
      };
    };

    services = mkIf cfg.reverseProxy.enable {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "git.${cfg.reverseProxy.domain}" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://192.168.100.12:4000/";
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
