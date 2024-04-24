{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.searx;
in {
  options.services.searx.customConf = {
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
            secret_key = "asecretkeychangethis";
          };

          search = {
            safe_search = 2;
            autocomplete = "duckduckgo";
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
