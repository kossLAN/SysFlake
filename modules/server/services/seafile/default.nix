{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.seafile;
in {
  options.services.seafile.customConf = {
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
      seafile = {
        adminEmail = "kosslan@kosslan.dev";
        initialAdminPassword = "root"; # <----- CHANGE VIA WEB UI
        ccnetSettings = {
          General.SERVICE_URL = "http://cloud.kosslan.dev"; # This formatting goes crazy (not really)
        };
        seafileSettings = {
          fileserver = {
            # These are the default settings, but I'd rather them here for documentation
            host = "127.0.0.1";
            port = 8082;

            max_upload_size = 50000;
            max_download_dir_size = 50000;
          };
          quota = {
            # default user quota in GB.
            default = 5;
          };
          history = {
            # days of history to keep
            keep_days = 30;
          };
        };
      };

      # NGINX Reverse Proxy
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "cloud.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:8082/";
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
  };
}
