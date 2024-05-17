{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.forgejo;
in {
  options.services.forgejo = {
    container.enable = lib.mkEnableOption "Forgjo custom configuration";
  };

  config = lib.mkIf cfg.container.enable {
    networking = {
      firewall.allowedTCPPorts = [80 443 2222];

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "eno1";
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
            allowedTCPPorts = [4000 2222];
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
                HTTP_ADDR = "0.0.0.0";
                HTTP_PORT = 4000;
                DOMAIN = "git.kossland.dev";
                ROOT_URL = "https://git.kosslan.dev";

                START_SSH_SERVER = true;
                BUILTIN_SSH_SERVER_USER = "git";
                SSH_LISTEN_PORT = 2222;
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

              # metrics.ENABLED = true;
            };
          };
        };

        system.stateVersion = "23.11";
      };

      bindMounts = {
        "/var/lib/forgejo" = {
          isReadOnly = false;
          hostPath = "/var/lib/forgejo";
        };
      };
    };

    services = {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "git.kosslan.dev" = {
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
