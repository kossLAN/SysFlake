{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.unpackerr;
  tomlFormat = pkgs.formats.toml {};
in {
  options.services.unpackerr = {
    enable = mkEnableOption "Enable Unpackerr Service.";

    user = mkOption {
      type = lib.types.str;
      default = "unpackerr";
      description = "User to run unpackerr as.";
    };

    group = mkOption {
      type = lib.types.str;
      default = "unpackerr";
      description = "Group to run unpackerr as.";
    };

    settings = mkOption {
      type = tomlFormat.type;
      default = {};
      description = ''
        Configuration file following the options provided by unpackerr:
        https://notifiarr.com/unpackerr
      '';
      example = lib.literalExpression ''
        {
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
              api_key = "0123456789abcdef0123456789abcdef";
              paths = ["/downloads"];
              protocols = "torrent";
              timeout = "10s";
              delete_delay = "5m";
              delete_orig = false;
              syncthing = false;
            }
          ];
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.unpackerr = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      requires = ["network.target"];
      description = "Unpackerr Service";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "10";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe pkgs.unpackerr} -c ${
          tomlFormat.generate "unpackerr.conf" cfg.settings
        }";
      };
    };
  };
}
