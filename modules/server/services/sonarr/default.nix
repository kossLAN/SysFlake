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
      virtualHosts."sonarr.${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8989/";
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
