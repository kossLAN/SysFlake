{...}: let
  external-mac = "3c:ec:ef:30:10:3d";
  ext-if = "eno4";
  external-ip = "185.150.189.28";
  external-gw = "185.150.189.1";
  external-netmask = 24;
in {
  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "server";
    };

    udev.extraRules = ''SUBSYSTEM=="net", ATTR{address}=="${external-mac}", NAME="${ext-if}"'';
  };

  networking = {
    nameservers = ["1.1.1.1" "8.8.8.8"];
    interfaces."${ext-if}" = {
      ipv4.addresses = [
        {
          address = external-ip;
          prefixLength = external-netmask;
        }
      ];
    };
    defaultGateway = external-gw;

    # AirVPN Connection
    # wg-quick.interfaces = {
    #   "av0" = {
    #     autostart = true;
    #     address = ["10.137.214.184"];
    #     privateKeyFile = config.age.secrets.av0client1.path;
    #     mtu = 1320;
    #     dns = ["10.128.0.1"];
    #
    #     peers = [
    #       {
    #         publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
    #         presharedKeyFile = config.age.secrets.av0preshared.path;
    #         endpoint = "us3.vpn.airdns.org:51820";
    #         allowedIPs = ["192.168.100.13/32"];
    #         persistentKeepalive = 15;
    #       }
    #     ];
    #   };
    # };
  };
}
