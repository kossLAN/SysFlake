{
  lib,
  config,
  stateVersion,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.plex;
in {
  options.services.plex = {
    arr.enable = mkEnableOption "Sonnar service";
    customConf = mkEnableOption "Plex custom config";
  };

  config = mkIf cfg.customConf {
    networking = {
      firewall.allowedTCPPorts = [80 443];
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "kosslan@kosslan.dev";
    };

    containers.arr = mkIf cfg.arr.enable {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.13";
      config = let
        vpnAddress = "10.137.214.184";
      in {
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [8112 58846];
          };

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;

          # Find a fix for this not starting before the first interface
          wg-quick.interfaces = {
            # AirVPN Connection :-)
            "av0" = {
              autostart = true;
              address = [vpnAddress];
              privateKey = config.secrets.airvpn1.privateKey;
              mtu = 1320;
              dns = ["10.128.0.1"];

              peers = [
                {
                  publicKey = config.secrets.airvpn1.publicKey;
                  presharedKey = config.secrets.airvpn1sharedkey.privateKey;
                  endpoint = "us3.vpn.airdns.org:51820";
                  allowedIPs = ["0.0.0.0/0"];
                  persistentKeepalive = 15;
                }
              ];
            };
          };
        };

        services = {
          resolved.enable = true;

          deluge = {
            enable = true;
            declarative = true;
            authFile = pkgs.writeText "authFile" config.secrets.deluge.privateKey;

            web = {
              enable = true;
              port = 8112;
            };

            config = {
              download_location = "/srv/torrents/";
              max_upload_speed = "200.0";
              share_ratio_limit = "2.0";
              allow_remote = true;
              daemon_port = 58846;
              listen_interface = vpnAddress;
              listen_ports = [43567 36060]; # Ports from AirVPN
              enabled_plugins = ["Label"];
            };
          };
        };

        system.stateVersion = stateVersion;
      };
    };

    services = {
      plex = {
        openFirewall = true;
      };

      sonarr = mkIf cfg.arr.enable {
        enable = true;
      };

      prowlarr = mkIf cfg.arr.enable {
        enable = true;
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "sonarr.kosslan.dev" = mkIf cfg.arr.enable {
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

          "prowlarr.kosslan.dev" = mkIf cfg.arr.enable {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:9696/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_ssl_server_name on;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };

          "deluge.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://192.168.100.13:8112";
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
