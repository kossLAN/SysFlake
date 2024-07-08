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

    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."seer.${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:5055/";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_ssl_server_name on;
              proxy_pass_header Authorization;
            '';
          };
        };
      };
    };
  };
}
