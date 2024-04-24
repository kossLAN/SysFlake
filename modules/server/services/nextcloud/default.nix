{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.nextcloud;
in {
  options.services.nextcloud = {
    customConf.enable = lib.mkEnableOption "Nextcloud management";
  };

  # Don't really use this much anymore...
  config = lib.mkIf cfg.customConf.enable {
    environment.etc."nc-adminpass".text = "root";

    networking.firewall.allowedTCPPorts = [80 443];

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
        package = pkgs.nextcloud28;
        hostName = "nextcloud.kosslan.dev";
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
          trusted_domains = ["nextcloud.kosslan.dev"];
          trusted_proxies = ["nextcloud.kosslan.dev"];
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
          adminpassFile = "/etc/nc-adminpass";
          dbtype = "mysql";
        };

        caching = {
          redis = true;
          memcached = true;
        };
      };

      nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        enableACME = true;
      };
    };

    # SSL CERT
    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    # NGINX
    # nginx = {
    #   enable = true;
    #   recommendedProxySettings = true;
    #   recommendedTlsSettings = true;
    #   virtualHosts = {
    #     "nextcloud.kosslan.dev" = {
    #       enableACME = true;
    #       forceSSL = true;
    #       locations = {
    #         "\\.php" = {
    #           proxyPass = "http://127.0.0.1/";
    #           proxyWebsockets = true;
    #           extraConfig = ''
    #             proxy_ssl_server_name on;
    #             proxy_pass_header Authorization;
    #           '';
    #         };
    #       };
    #     };
    #   };
    # };
  };
}
