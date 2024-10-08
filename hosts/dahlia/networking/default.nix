{config, ...}: let
  domain = "kosslan.dev";
  interface = "enp1s0"; # WAN interface
  cerebrite = "100.64.0.4";
in {
  services = {
    headscale = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      authKeyFile = config.age.secrets.tailscale.path;

      extraUpFlags = [
        "--login-server=http://localhost:3442"
        "--advertise-exit-node=true"
        "--advertise-routes=0.0.0.0/0"
      ];
    };

    caddy = {
      enable = true;
      landingPage = true;
      virtualHosts = {
        # Jellyfin (Media Server)
        "jellyfin.${domain}".extraConfig = ''
          reverse_proxy http://${cerebrite}:8096
        '';

        "seer.${domain}".extraConfig = ''
          reverse_proxy http://${cerebrite}:5055
        '';

        # Portainer (docker management thing)
        "portainer.${domain}".extraConfig = ''
          reverse_proxy http://${cerebrite}:9000
        '';

        # Git Instance
        "git.${domain}".extraConfig = ''
          reverse_proxy http://${cerebrite}:4000
        '';

        # Tailnet Services
        "http://prometheus.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:3255
        '';

        "http://grafana.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:3000
        '';

        "http://sync.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:8384
        '';

        "http://deluge.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:8112
        '';

        "http://radarr.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:7878
        '';

        "http://sonarr.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:8989
        '';

        "http://lidarr.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:8686
        '';

        "http://prowlarr.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:9696
        '';
      };
    };
  };

  # Tailnet DNS
  deployment.tailnetSubdomains = [
    "prometheus"
    "grafana"
    "sync"
    "deluge"
    "radarr"
    "sonarr"
    "lidarr"
    "prowlarr"
  ];

  routing.services = [
    # Git SSH Server
    {
      interface = interface;
      proto = "tcp";
      dport = "22";
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
  ];

  networking = {
    firewall.allowedTCPPorts = [80 443];

    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
