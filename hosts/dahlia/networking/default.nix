{...}: let
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
      useRoutingFeatures = "server";
      extraUpFlags = ["--login-server http://localhost:3442"];
    };

    caddy = {
      enable = true;
      landingPage = true;
      virtualHosts = {
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

        "http://sync.ts.net".extraConfig = ''
          reverse_proxy http://${cerebrite}:8384
        '';
      };
    };
  };

  # Tailnet DNS
  deployment.tailnetSubdomains = ["prometheus" "sync"];

  routing.services = [
    # Git SSH Server
    {
      interface = interface;
      proto = "tcp";
      dport = "22";
      ipAddress = cerebrite;
    }

    # Catch all port range (mostly for quick docker setup)
    {
      interface = interface;
      proto = "tcp";
      dport = "10000:65535";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "10000:65535";
      ipAddress = cerebrite;
    }
  ];

  networking = {
    firewall.allowedTCPPorts = [80 443];

    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
