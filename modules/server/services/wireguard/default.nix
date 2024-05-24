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
        # settings = {
        #   bind_port = 3000;
        #   bind_host = "127.0.0.1";
        # };
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
        allowedTCPPorts = [80 443];
        allowedUDPPorts = [51820 51821 53];
      };

      nat = {
        enable = true;
        externalInterface = "eno1";
        internalInterfaces = ["wg0" "wg1"];
      };

      wireguard.interfaces = {
        wg0 = {
          ips = ["10.100.0.1/24"];
          listenPort = 51820;

          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eno1 -j MASQUERADE
          '';

          # This undoes the above command
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eno1 -j MASQUERADE
          '';

          privateKey = config.secrets.wg0server.privateKey;
          peers = [
            {
              publicKey = config.secrets.wg0client1.publicKey;
              allowedIPs = ["10.100.0.4/32"]; # Its this because I'm too lazy to change on the client ;-)
            }
          ];
        };

        # Phone
        wg1 = {
          ips = ["10.100.1.1/24"];
          listenPort = 51821;

          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.1.0/24 -o eno1 -j MASQUERADE
          '';

          # This undoes the above command
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.1.0/24 -o eno1 -j MASQUERADE
          '';

          privateKey = config.secrets.wg1server.privateKey;
          peers = [
            {
              publicKey = config.secrets.wg1client1.publicKey;
              allowedIPs = ["10.100.1.2/32"];
            }
          ];
        };
      };
    };
  };
}
