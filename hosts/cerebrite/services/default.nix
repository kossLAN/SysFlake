{...}: {
  # This is a long list of things I have enabled on this server
  # It's a dedicated box so thats mostly the reason, but potentially
  # would be better off with a few more boxes idk
  virtualisation = {
    flaresolverr.enable = true;

    portainer = {
      enable = true;
      reverseProxy.enable = true;
    };
  };

  services = {
    ssh = {
      enable = true;
    };

    plex = {
      enable = true;
      defaults.enable = true;
    };

    firefox-syncserver = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    jellyfin = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    arr = {
      enable = true;
      domain = "kosslan.dev";
    };

    searx = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    syncthing = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    wireguard = {
      enable = true;
      adguardhome = {
        enable = true;
        reverseProxy.enable = true;
      };
    };

    forgejo = {
      container.enable = true;
      reverseProxy.enable = true;
    };

    nextcloud = {
      container.enable = true;
      reverseProxy.enable = true;
    };

    prometheus = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };
  };
}
