{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.plex;
in {
  options.services.plex = {
    customConf = mkEnableOption "Plex custom config";
  };

  config = mkIf cfg.customConf {
    services = {
      plex = {
        openFirewall = true;
      };
    };
  };
}
