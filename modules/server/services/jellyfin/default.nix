{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.jellyfin;
in {
  options.services.jellyfin = {
    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.reverseProxy.enable [80 443];

    services = {
      caddy = mkIf cfg.reverseProxy.enable {
        enable = true;
        virtualHosts."jellyfin.${cfg.reverseProxy.domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:8096
        '';
      };
    };
  };
}
