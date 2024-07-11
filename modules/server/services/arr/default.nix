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
