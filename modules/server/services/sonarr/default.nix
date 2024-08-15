{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.sonarr.reverseProxy;
in {
  options.services.sonarr.reverseProxy = {
    enable = mkEnableOption "Enable the reverse proxy";

    tailnet = mkOption {
      type = lib.types.bool;
      default = false;
    };

    domain = mkOption {
      type = lib.types.str;
      default = "kosslan.dev";
    };
  };

  config = mkIf cfg.enable {
    deployment.tailnetSubdomains = mkIf cfg.tailnet ["sonarr"];

    networking = {
      firewall.allowedTCPPorts = [80 443];
    };

    services.caddy = {
      enable = true;
      virtualHosts."http://sonarr.${cfg.domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:8989
      '';
    };
  };
}
