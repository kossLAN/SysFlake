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

    settings = mkOption {
      type = tomlFormat.type;
      default = {};
      description = ''
        Configuration file following the options provided by unpackerr:
        https://notifiarr.com/unpackerr
      '';
      example = lib.literalExpression ''
        {
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.unpackerr = {
      wantedBy = ["multi-user.target"];
      description = "Unpackerr Service";
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe pkgs.unpackerr} -c ${
          tomlFormat.generate "unpackerr.conf" cfg.settings
        }";
      };
    };
  };
}
