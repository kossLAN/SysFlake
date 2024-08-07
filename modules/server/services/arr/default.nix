{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.arr;
in {
  options.services.arr = {
    enable = mkEnableOption "Enable the ARR Suite";

    user = mkOption {
      type = lib.types.str;
      default = config.users.defaultUser;
    };

    group = mkOption {
      type = lib.types.str;
      default = config.users.defaultUser;
    };

    dataDir = mkOption {
      type = lib.types.str;
      default = "/var/lib/";
    };

    radarrApiKey = mkOption {
      type = lib.types.path;
      default = "";
    };

    sonarrApiKey = mkOption {
      type = lib.types.path;
      default = "";
    };

    lidarrApiKey = mkOption {
      type = lib.types.path;
      default = "";
    };

    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy for the ARR Suite";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      # NixOS Module that manages TV shows
      sonarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.dataDir}/NzbDrone";

        reverseProxy = {
          enable = cfg.reverseProxy.enable;
          domain = cfg.reverseProxy.domain;
        };
      };

      # NixOS Module that manages movies
      radarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.dataDir}/Radarr";

        reverseProxy = {
          enable = cfg.reverseProxy.enable;
          domain = cfg.reverseProxy.domain;
        };
      };

      # NixOS Module that manages music
      lidarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.dataDir}/Lidarr";

        reverseProxy = {
          enable = cfg.reverseProxy.enable;
          domain = cfg.reverseProxy.domain;
        };
      };

      # NixOS Module that manages indexers
      prowlarr = {
        enable = true;
        reverseProxy = {
          enable = cfg.reverseProxy.enable;
          domain = cfg.reverseProxy.domain;
        };
      };

      # Custom NixOS module for unpackerr (unarchive files downloaded from torrents)
      unpackerr = {
        enable = true;
        user = "root";
        group = "root";

        lidarrKeyFile = cfg.lidarrApiKey;

        # For more information on this see module description.
        settings = {
          debug = false;
          quiet = false;
          error_stderr = false;
          activity = false;
          log_queues = "1m";
          log_files = 10;
          log_file_mb = 10;
          interval = "2m";
          start_delay = "1m";
          retry_delay = "5m";
          max_retries = 3;
          parallel = 1;
          file_mode = "0644";
          dir_mode = "0755";

          lidarr = [
            {
              url = "http://127.0.0.1:8686";
              api_key = cfg.lidarrApiKey;
              paths = ["/home/${config.users.defaultUser}/downloads"];
              protocols = "torrent";
              timeout = "10s";
              delete_delay = "5m";
              delete_orig = false;
              syncthing = false;
            }
          ];
          #
          #   radarr = [
          #     {
          #       url = "http://127.0.0.1:7878";
          #       api_key = "0123456789abcdef0123456789abcdef";
          #       paths = ["/downloads"];
          #       protocols = "torrent";
          #       timeout = "10s";
          #       delete_delay = "5m";
          #       delete_orig = false;
          #       syncthing = false;
          #     }
          #   ];
          #
          #   sonarr = [
          #     {
          #       url = "http://127.0.0.1:8989";
          #       api_key = "0123456789abcdef0123456789abcdef";
          #       paths = ["/downloads"];
          #       protocols = "torrent";
          #       timeout = "10s";
          #       delete_delay = "5m";
          #       delete_orig = false;
          #       syncthing = false;
          #     }
          #   ];
        };
      };

      jellyseerr = {
        enable = true;
        reverseProxy = {
          enable = cfg.reverseProxy.enable;
          domain = cfg.reverseProxy.domain;
        };
      };
    };
  };
}
