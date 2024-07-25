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
    defaults.enable = mkEnableOption "Plex custom config";
  };

  config = mkIf cfg.defaults.enable {
    services = {
      plex = {
        openFirewall = true;
      };
    };
  };
}
