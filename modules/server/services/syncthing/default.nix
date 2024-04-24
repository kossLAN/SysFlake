{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.syncthing;
in {
  options.services.syncthing = {
    customConf = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.customConf {
    networking.firewall.allowedTCPPorts = [80 443];

    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 204800;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      syncthing = {
        guiAddress = "127.0.0.1:8384";
        openDefaultPorts = true;
        user = "syncthing";
        group = "syncthing";
        settings = {
          gui = {
            insecureSkipHostcheck = true;
          };
        };
        # all_proxy = "https://sync.kosslan.dev/";
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
