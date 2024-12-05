{deployment, ...}: {
  services = {
    tailscale.enable = true;

    caddy = {
      enable = true;

      domains = let
        localhost = "localhost";
      in {
        "kosslan.me" = {
          reverseProxyList = [
            {
              extraConfig = ''
                header Content-Type text/html
                respond "
                  <html>
                    <head><title>Cerebrite</title></head>
                    <body>
                      <h3>You are connected to the tailnet.</h3>
                    </body>
                  </html>
                "
              '';
            }
            {
              subdomain = "deluge";
              address = deployment.containerHostIp "deluge";
              port = 8112;
            }
            {
              subdomain = "sonarr";
              address = localhost;
              port = 8989;
            }
            {
              subdomain = "radarr";
              address = localhost;
              port = 7878;
            }
            {
              subdomain = "lidarr";
              address = localhost;
              port = 8686;
            }
            {
              subdomain = "prowlarr";
              address = localhost;
              port = 9696;
            }
            {
              subdomain = "sync";
              address = localhost;
              port = 8384;
            }
            {
              subdomain = "cloud";
              address = deployment.containerHostIp "nextcloud";
              port = 80;
            }
            {
              subdomain = "netdata";
              address = localhost;
              port = 19999;
            }
          ];
        };
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [443 80];
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
