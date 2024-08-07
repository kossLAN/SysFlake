{config, ...}: {
  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };

  networking = {
    # AirVPN Connection
    wg-quick.interfaces = {
      "av0" = {
        autostart = true;
        address = ["10.137.214.184"];
        privateKeyFile = config.age.secrets.av0client1.path;
        mtu = 1320;
        dns = ["10.128.0.1"];

        peers = [
          {
            publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
            presharedKeyFile = config.age.secrets.av0preshared.path;
            endpoint = "us3.vpn.airdns.org:51820";
            allowedIPs = ["192.168.100.13/32"];
            persistentKeepalive = 15;
          }
        ];
      };
    };
  };
}
