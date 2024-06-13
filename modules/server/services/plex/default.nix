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
    # networking.firewall = lib.mkIf cfg.openFirewall {
    #   allowedTCPPorts = [32400 8324 32469];
    #   allowedUDPPorts = [1900 5353 32410 32412 32413 32414];
    # };
    services.plex = {
      openFirewall = true;
    };
  };
}
