{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.wireguard;
in {
  options.services.wireguard = {
    enable = lib.mkEnableOption "Wireguard VPN";
    adguardhome.enable = lib.mkEnableOption "Wireguard with adguardhome support";
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    services = {
      adguardhome = lib.mkIf cfg.adguardhome.enable {
        enable = true;
        mutableSettings = true;
        settings = {
          bind_port = 3000;
          bind_host = "127.0.0.1";
        };
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "adguard.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:3000/";
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

    networking = {
      firewall = {
        allowedTCPPorts = [53 3000 80 443];
        allowedUDPPorts = [51820 53];
      };

      nat = {
        enable = true;
        externalInterface = "eno1";
        internalInterfaces = ["wg0"];
      };

      wireguard.interfaces = {
        wg0 = {
          ips = ["10.100.0.1/24"];
          listenPort = 51820;

          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';

          # This undoes the above command
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';

          privateKeyFile = "/etc/wg-private";
          peers = [
            # Phone
            {
              publicKey = "VZM6vpIOfaG2HyeQ1dnlvQqlv1Qx63C3uvS1kAlnwXQ=";
              allowedIPs = ["10.100.0.2/32"];
            }
            # Everything else
            {
              publicKey = "VZM6vpIOfaG2HyeQ1dnlvQqlv1Qx63C3uvS1kAlnwXQ=";
              allowedIPs = ["10.100.0.3/32"];
            }
          ];
        };
      };
    };
  };
}
