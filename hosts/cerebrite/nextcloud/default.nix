{
  lib,
  pkgs,
  config,
  deployment,
  ...
}: let
  inherit (lib.modules) mkIf;

  domain = "cloud.kosslan.me";
  externalInterface = "wlp5s0";
in {
  # Make the folder that will be mounted if it doesn't already exist.
  # systemd.tmpfiles.rules = [
  #   "d /var/lib/storage 1755 ${deployment.serviceUID "nextcloud"} ${deployment.serviceGID "storage"}"
  # ];

  deployment.containers.nextcloud.owner = "nextcloud";

  networking = {
    firewall.allowedTCPPorts = [80 443];

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = externalInterface;
    };
  };

  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = deployment.containerHostIp "nextcloud";
    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 5000;
        protocol = "tcp";
      }
    ];

    config = {
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
        users.nextcloud.uid = deployment.serviceUID "nextcloud";
        groups.nextcloud.gid = deployment.serviceGID "storage";
      };

      services = {
        resolved.enable = true;

        nextcloud = {
          enable = true;
          package = pkgs.nextcloud30;
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
            trusted_domains = [domain];
            trusted_proxies = ["192.168.100.10"];
            log_type = "file";
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
            # :troll:
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
      "/var/lib/storage" = mkIf config.services.syncthing.enable {
        isReadOnly = false;
        hostPath = "/var/lib/syncthing";
      };
    };
  };
}
