{config, ...}: {
  networking = {
    wg-quick.interfaces.wg0 = {
      autostart = false;
      privateKeyFile = config.age.secrets.wg0client1.path;
      mtu = 1320;

      dns = [
        "10.128.0.1"
        "fd7d:76ee:e68f:a993::1"
      ];

      address = [
        "10.135.226.40/32"
        "fd7d:76ee:e68f:a993:8ef7:d378:c776:b86d/128"
      ];

      peers = [
        {
          publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          presharedKeyFile = config.age.secrets.wg0preshared.path;
          endpoint = "br3.vpn.airdns.org:1637";
          allowedIPs = ["0.0.0.0/0"];
          persistentKeepalive = 15;
        }
      ];
    };
  };
}
