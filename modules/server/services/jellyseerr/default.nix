{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.jellyseerr.reverseProxy;
in {
  options.services.jellyseerr.reverseProxy = {
    enable = mkEnableOption "Enable the reverse proxy";
    domain = mkOption {
      type = lib.types.str;
      default = "kosslan.dev";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall.allowedTCPPorts = [80 443];
    };

    services.caddy = {
      enable = true;
      virtualHosts."seer.${cfg.domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:5055
      '';
    };
  };
}
