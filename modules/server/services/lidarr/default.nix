{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.lidarr.reverseProxy;
in {
  options.services.lidarr.reverseProxy = {
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
    deployment.tailnetSubdomains = mkIf cfg.tailnet ["lidarr"];

    networking = {
      firewall.allowedTCPPorts = [80 443];
    };

    services.caddy = {
      enable = true;
      virtualHosts."http://lidarr.${cfg.domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:8686
      '';
    };
  };
}
