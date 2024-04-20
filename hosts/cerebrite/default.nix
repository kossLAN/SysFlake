{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ./hardware
    outputs.universalModules
    outputs.nixosModules
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 1d";

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  boot = {
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    loader.grub = {
      efiSupport = true;
      enable = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  environment.etc."nc-adminpass".text = "root";

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 204800;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "kosslan@proton.me";
  };

  networking = {
    hostName = "cerebrite";

    firewall = {
      allowedTCPPorts = [80 443 8384];
      allowedUDPPorts = [21027 22000 51820];
    };

    nat = {
      enable = true;
      externalInterface = "eth0";
      internalInterfaces = ["wg0"];
    };

    wireguard.interfaces = {
      wg0 = {
        ips = ["10.100.0.1/24"];
        listenPort = 51820;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';

        privateKeyFile = "/etc/wg-private";
        peers = [
          # Phone
          {
            publicKey = "VZM6vpIOfaG2HyeQ1dnlvQqlv1Qx63C3uvS1kAlnwXQ=";
            allowedIPs = ["10.100.0.2/32"];
          }
          # Everything else
          {
            publicKey = "VZM6vpIOfaG2HyeQ1dnlvQqlv1Qx63C3uvS1kAlnwXQ=";
            allowedIPs = ["10.100.0.3/32"];
          }
        ];
      };
    };

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
      openssh = {
        enable = true;
      };

      plex = {
        enable = true;
      };

      syncthing = {
        enable = true;
        guiAddress = "0.0.0.0:8384";
        user = "nextcloud";
        group = "nextcloud";
        dataDir = "/var/lib/nextcloud";
      };

      nextcloud = {
        enable = true;
        package = pkgs.nextcloud28;
        hostName = "nextcloud.kosslan.dev";
        appstoreEnable = true;

        configureRedis = true;
        notify_push.enable = false;
        https = true;
        maxUploadSize = "50G";

        phpExtraExtensions = all: [all.smbclient all.inotify];

        phpOptions = {
          post_maxs_size = "50G";
          "opcache.interned_strings_buffer" = "32";
          "opcache.max_accelerated_files" = "10000";
          "opcache.memory_consumption" = "128";
        };

        settings = {
          trusted_domains = ["nextcloud.kosslan.dev"];
          trusted_proxies = ["192.168.10.115" "192.168.10.102" "nextcloud.kosslan.dev"];
          enabledPreviewProviders = [
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

          "filelocking.enabled" = true;
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

      # NGINX
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "nextcloud.kosslan.dev" = {
            serverAliases = ["cloud.kosslan.dev"];
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1";
                proxyWebsockets = true;
                extraConfig = ''
                  limit_rate 30m;
                  client_max_body_size 50G;
                  client_body_timeout 300s;
                  fastcgi_buffers 64 4K;
                  client_body_buffer_size 512k;
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
