{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.radarr.reverseProxy;
in {
  options.services.radarr.reverseProxy = {
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
    deployment.tailnetSubdomains = mkIf cfg.tailnet ["radarr"];

    networking = {
      firewall.allowedTCPPorts = [80 443];
    };

    services.caddy = {
      enable = true;
      virtualHosts."http://radarr.${cfg.domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:7878
      '';
    };
  };
}
