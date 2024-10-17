{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;

  cfg = config.services.caddy;
in {
  options.services.caddy = {
    domains = mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          reverseProxyList = mkOption {
            type = lib.types.listOf (lib.types.submodule {
              options = {
                subdomain = mkOption {
                  type = lib.types.str;
                  default = "";
                };
                address = mkOption {
                  type = lib.types.str;
                };
                port = mkOption {
                  type = lib.types.int;
                };
              };
            });
          };
        };
      });

      default = [];

      description = ''
        List of reverse proxies for various services, mapped to caddy.
        -- Example:
        domains = {
          "kosslan.me" = {
            reverseProxyList = [
              {
                subdomain = "sync";
                address = "localhost";
                port = 8384;
              }
            ];
          };
        };
      '';
    };
  };

  config = mkIf (cfg.domains != []) {
    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@kosslan.dev";
      certs =
        lib.mapAttrs (name: _: {
          group = "caddy";
          reloadServices = ["caddy.service"];
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          extraDomainNames = ["*.${name}"];
          environmentFile = config.deployment.cfKeyFile;
        })
        cfg.domains;
    };

    services.caddy = {
      virtualHosts = lib.foldl' (
        acc: domain:
          lib.foldl' (
            innerAcc: proxy:
              innerAcc
              // {
                "${
                  if (proxy.subdomain == "")
                  then domain
                  else "${proxy.subdomain}.${domain}"
                }" = {
                  extraConfig = ''
                    reverse_proxy http://${proxy.address}:${toString proxy.port}
                    tls /var/lib/acme/${domain}/cert.pem /var/lib/acme/${domain}/key.pem
                  '';
                };
              }
          )
          acc (cfg.domains.${domain}.reverseProxyList)
      ) {} (lib.attrNames cfg.domains);
    };
  };
}
