{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.syncthing;
in {
  options.services.syncthing = {
    container.enable = lib.mkEnableOption "syncthing container";
  };

  config = lib.mkIf cfg.container.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [80 443 22000];
        allowedUDPPorts = [21027];
      };

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "eno1";
        # Lazy IPv6 connectivity for the container
        enableIPv6 = true;
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/storage 0755 8000 8000"
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    containers.syncthing = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.12";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::3";
      config = {
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [8384 22000];
            allowedUDPPorts = [21027];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        boot.kernel.sysctl = {
          "fs.inotify.max_user_watches" = 204800;
        };

        users = {
          users.storage = {
            isSystemUser = true;
            group = "storage";
            uid = 8000;
          };
          groups.storage.gid = 8000;
        };

        systemd.tmpfiles.rules = [
          "d /var/lib/syncthing 0700 8000 8000"
        ];

        services = {
          resolved.enable = true;
          syncthing = {
            guiAddress = "0.0.0.0:8384";
            user = "storage";
            group = "storage";

            dataDir = "/var/lib/syncthing/files";
            configDir = "/var/lib/syncthing";
            settings = {
              gui.insecureSkipHostcheck = true;
            };
            enable = true;
          };
        };
        system.stateVersion = "23.11";
      };

      bindMounts = {
        "/var/lib/storage" = {
          isReadOnly = false;
          hostPath = "/var/lib/storage";
        };
      };
    };

    services = {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "sync.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://192.168.100.12:8384";
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
