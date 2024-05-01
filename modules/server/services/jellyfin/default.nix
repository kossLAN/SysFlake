{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.jellyfin;
in {
  options.services.jellyfin.customConf = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.customConf.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    # SSL CERT
    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      # I might set up more things here, for now this is just for Reverse Proxy
      # jellyfin = {
      #
      # };
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "jellyfin.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:8096/";
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
    };

    # NGINX Reverse Proxy
  };
}
