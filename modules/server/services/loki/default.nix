{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.loki;
in {
  options.services.loki = {
    defaults = {
      enable = mkEnableOption "Firefox sync server configuration";
    };
  };

  config = mkIf cfg.defaults.enable {
    services.loki.configFile = ./loki.yaml;

    systemd.services.promtail = {
      description = "Promtail service for Loki";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
        '';
      };
    };
  };
}
