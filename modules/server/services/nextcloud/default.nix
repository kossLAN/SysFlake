{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.nextcloud;
in {
  options.services.nextcloud = {
    container.enable = lib.mkEnableOption "Nextcloud container";
  };

  # Don't really use this much anymore...
  config = lib.mkIf cfg.container.enable {
    networking = {
      firewall.allowedTCPPorts = [80 443];

      bridges.br0.interfaces = []; # Adjust interface accordingly

      # Get bridge-ip with DHCP
      useDHCP = false;
      interfaces."br0".useDHCP = true;

      # Set bridge-ip static
      interfaces."br0".ipv4.addresses = [
        {
          address = "192.168.100.3";
          prefixLength = 24;
        }
      ];
      defaultGateway = "192.168.100.1";
      nameservers = ["192.168.100.1"];
    };

    containers.nextcloud = {
      privateNetwork = true;
      hostBridge = "br0"; # Specify the bridge name
      localAddress = "192.168.100.5/24";
      config = {
        systemd.services."inotify-nextcloud" = {
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          description = "Run inotify watcher for nextcloud.";
          serviceConfig = {
            Type = "simple";
            User = "root";
            ExecStart = ''
              ${config.system.path}/bin/nextcloud-occ files_external:notify -v 1 &
            '';
            Restart = "on-failure";
          };
        };

        services = {
          nextcloud = {
            enable = true;
            package = pkgs.nextcloud28;
            hostName = "localhost";
            https = true;

            appstoreEnable = true;
            configureRedis = true;
            notify_push.enable = false;
            maxUploadSize = "50G";

            phpExtraExtensions = all: [all.smbclient all.inotify];

            phpOptions = {
              "opcache.interned_strings_buffer" = "32";
              "opcache.max_accelerated_files" = "10000";
              "opcache.memory_consumption" = "128";
            };

            settings = {
              trusted_domains = ["cloud.kosslan.dev"];
              trusted_proxies = ["cloud.kosslan.dev"];
              "filelocking.enabled" = true;

              "enabledPreviewProviders" = [
                "OC\\Preview\\BMP"
                "OC\\Preview\\GIF"
                "OC\\Preview\\JPEG"
                "OC\\Preview\\Krita"
                "OC\\Preview\\MarkDown"
                "OC\\Preview\\MP3"
                "OC\\Preview\\OpenDocument"
                "OC\\Preview\\PNG"
                "OC\\Preview\\TXT"
                "OC\\Preview\\XBitmap"
                "OC\\Preview\\HEIC"
              ];
            };

            database.createLocally = true;

            config = {
              adminpassFile = "${pkgs.writeText "adminpass" "password123"}";
              dbtype = "sqlite";
            };

            caching = {
              redis = true;
              memcached = true;
            };
          };
        };
        system.stateVersion = "23.11";
      };
    };

    # SSL CERT
    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    # NGINX
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "cloud.kosslan.dev" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://192.168.100.5/";
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
