{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.nextcloud;
in {
  options.services.nextcloud = {
    container = {
      enable = mkEnableOption "Nextcloud container with opinionated defaults";
    };
    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.container.enable {
    networking = {
      firewall.allowedTCPPorts = [80 443];

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "eno1";
      };
    };

    # Make the folder that will be mounted if it doesn't already exist.
    systemd.tmpfiles.rules = [
      "d /var/lib/storage 1755 8000 8000"
    ];

    containers.nextcloud = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
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
            package = pkgs.nextcloud29;
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
              trusted_proxies = ["192.168.100.10"];
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
              # Temp password, changed on setup
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
    security.acme = mkIf cfg.reverseProxy.enable {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    # NGINX
    services.nginx = mkIf cfg.reverseProxy.enable {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        # Nextcloud
        "cloud.${cfg.reverseProxy.domain}" = {
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
