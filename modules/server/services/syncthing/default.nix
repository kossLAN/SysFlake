{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.syncthing;
in {
  options.services.syncthing = {
    customConf = mkEnableOption "Syncthing config";
  };

  config = mkIf cfg.customConf {
    networking = {
      firewall = {
        allowedTCPPorts = [80 443 22000];
        allowedUDPPorts = [21027];
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/storage 0755 8000 8000"
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    # Set syncthing to a unique ID that has a low low chance of being used elsewhere
    users = {
      users.syncthing = {
        isSystemUser = true;
        group = "syncthing";
        uid = lib.mkForce 8000;
      };
      groups.syncthing.gid = lib.mkForce 8000;
    };

    services = {
      syncthing = {
        relay.enable = false;
        overrideFolders = false;
        overrideDevices = false;
        guiAddress = "127.0.0.1:8384";

        settings = {
          gui = {
            insecureSkipHostcheck = true;
            user = "koss";
            password = config.secrets.syncthing.privateKey;
          };
        };
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "sync.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:8384";
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
