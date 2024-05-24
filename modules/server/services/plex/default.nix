{
  lib,
  config,
  ...
}: let
  cfg = config.services.plex;
in {
  options.services.plex = {
    customConf = lib.mkEnableOption "Plex custom config";
  };

  config = lib.mkIf cfg.customConf {
    # networking.firewall = lib.mkIf cfg.openFirewall {
    #   allowedTCPPorts = [32400 8324 32469];
    #   allowedUDPPorts = [1900 5353 32410 32412 32413 32414];
    # };
    services.plex = {
      openFirewall = true;
    };
  };
}
