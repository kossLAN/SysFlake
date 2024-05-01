{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.nextcloud;
in {
  options.services.nextcloud = {
    container = {
      enable = lib.mkEnableOption "Nextcloud container";
    };
  };

  # Don't really use this much anymore...
  config = lib.mkIf cfg.container.enable {
    networking = {
      firewall.allowedTCPPorts = [80 443];

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "eno1";
        # Lazy IPv6 connectivity for the container
        enableIPv6 = true;
      };
    };

    # Make the folder that will be mounted if it doesn't already exist.
    systemd.tmpfiles.rules = [
      "d /var/lib/storage 0755 8000 8000"
    ];

    containers.nextcloud = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
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

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [80];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        # Set nextcloud user to id 8000 so it can write properly
        # I could setup a better system for managing and keeping users
        # but for my use 8000 will just be the id I use :-)
        users = {
          users.nextcloud.uid = 8000;
          groups.nextcloud.gid = 8000;
        };

        services = {
          resolved.enable = true;

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
              trusted_proxies = ["cloud.kosslan.dev" "192.168.100.10"];
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
              adminpassFile = "${pkgs.writeText "adminpass" "password"}";
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

      bindMounts = {
        "/var/lib/storage" = {
          isReadOnly = false;
          hostPath = "/var/lib/storage";
        };
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
        # Nextcloud
        "cloud.kosslan.dev" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://192.168.100.11/";
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
