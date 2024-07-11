{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;

  cfg = config.services.searx;
in {
  options.services.searx = {
    customConf = mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.customConf {
    networking.firewall.allowedTCPPorts = [80 443];

    # SSL CERT
    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      searx = {
        redisCreateLocally = true;
        settings = {
          use_default_settings = true;

          general = {
            debug = false;
            instance_name = "SearXNG";
          };

          server = {
            port = 8888;
            bind_address = "127.0.0.1";
            secret_key = config.secrets.searx.privateKey;
            base_url = false;
            image_proxy = false;

            default_http_headers = {
              X-Content-Type-Options = "nosniff";
              X-XSS-Protection = "1; mode=block";
              X-Download-Options = "noopen";
              X-Robots-Tag = "noindex, nofollow";
              Referrer-Policy = "no-referrer";
            };
          };

          outgoing = {
            request_timeout = 2.0;
            pool_connections = 100;
            pool_maxsize = 10;
          };

          search = {
            safe_search = 2;
            autocomplete = "google";
            formats = ["html" "json"];
          };

          ui.static_use_hash = true;
        };
      };

      # NGINX Reverse Proxy
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "search.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:8888/";
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
