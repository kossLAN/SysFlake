{config, ...}: let
  interface = "enp1s0"; # WAN interface
  cerebrite = "100.64.0.4";
in {
  services = {
    headscale-custom = {
      enable = true;
      serverUrl = "https://kosslan.me";
      baseDomain = "ts.kosslan.me";
      tailnetDomain = "kosslan.me";
      tailnetSubdomains = [
        "sync"
        "cloud"
        "deluge"
        "radarr"
        "sonarr"
        "lidarr"
        "prowlarr"
        "netdata"
      ];
    };

    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      authKeyFile = config.age.secrets.tailscale.path;

      extraUpFlags = [
        "--login-server=http://localhost:3442"
        "--advertise-exit-node=true"
        "--advertise-routes=0.0.0.0/0,::/0"
      ];
    };

    caddy = {
      enable = true;

      domains = {
        "kosslan.dev" = {
          reverseProxyList = [
            {
              subdomain = "git";
              address = cerebrite;
              port = 4000;
            }
          ];
        };

        "kosslan.me" = {
          reverseProxyList = [
            {
              address = "localhost";
              port = 3442;
            }
            {
              subdomain = "jellyfin";
              address = cerebrite;
              port = 8096;
            }
            {
              subdomain = "seer";
              address = cerebrite;
              port = 5055;
            }
            {
              subdomain = "deluge";
              address = cerebrite;
              port = 8112;
              tailscale = true;
            }
            {
              subdomain = "sonarr";
              address = cerebrite;
              port = 8989;
              tailscale = true;
            }
            {
              subdomain = "radarr";
              address = cerebrite;
              port = 7878;
              tailscale = true;
            }
            {
              subdomain = "lidarr";
              address = cerebrite;
              port = 8686;
              tailscale = true;
            }
            {
              subdomain = "prowlarr";
              address = cerebrite;
              port = 9696;
              tailscale = true;
            }
            {
              subdomain = "sync";
              address = cerebrite;
              port = 8384;
              tailscale = true;
            }
            {
              subdomain = "cloud";
              address = cerebrite;
              port = 5000;
              tailscale = true;
            }
            {
              subdomain = "portainer";
              address = cerebrite;
              port = 9000;
            }
            {
              subdomain = "netdata";
              address = cerebrite;
              port = 19999;
              tailscale = true;
            }
          ];
        };
      };
    };
  };

  routing.services = [
    # Git SSH Server
    {
      interface = interface;
      proto = "tcp";
      dport = "22";
      ipAddress = cerebrite;
    }

    # Syncthing
    {
      interface = interface;
      proto = "tcp";
      dport = "22000";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "21027";
      ipAddress = cerebrite;
    }

    # Garry's Mod Server
    {
      interface = interface;
      proto = "udp";
      dport = "27005";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "tcp";
      dport = "27015";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "27015";
      ipAddress = cerebrite;
    }

    # Palworld server.
    {
      interface = interface;
      proto = "udp";
      dport = "8211";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "27016";
      ipAddress = cerebrite;
    }

    # Minecraft server.
    {
      interface = interface;
      proto = "tcp";
      dport = "25565";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "24454";
      ipAddress = cerebrite;
    }
  ];

  networking = {
    firewall.allowedTCPPorts = [80 443];

    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
