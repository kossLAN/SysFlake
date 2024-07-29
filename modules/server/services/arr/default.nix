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
    domain = mkOption {
      type = lib.types.str;
      default = "kosslan.dev";
    };
  };

  config = mkIf cfg.enable {
    services = {
      sonarr = {
        enable = true;
        reverseProxy = {
          enable = true;
          domain = cfg.domain;
        };
      };

      radarr = {
        enable = true;
        reverseProxy = {
          enable = true;
          domain = cfg.domain;
        };
      };

      lidarr = {
        enable = true;
        reverseProxy = {
          enable = true;
          domain = cfg.domain;
        };
      };

      prowlarr = {
        enable = true;
        reverseProxy = {
          enable = true;
          domain = cfg.domain;
        };
      };

      unpackerr = {
        enable = true;
        user = "root";
        group = "root";
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

          #   lidarr = [
          #     {
          #       url = "http://127.0.0.1:8686";
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
          enable = true;
          domain = cfg.domain;
        };
      };

      deluge = {
        container.enable = true;
        web.reverseProxy = {
          enable = true;
          domain = "kosslan.dev";
        };
      };
    };
  };
}
