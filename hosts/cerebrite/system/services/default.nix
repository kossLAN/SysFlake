{...}: {
  # This is a long list of things I have enabled on this server
  # It's a dedicated box so thats mostly the reason, but potentially
  # would be better off with a few more boxes idk
  virtualisation = {
    portainer.enable = true;
  };

  services = {
    ssh = {
      enable = true;
    };

    plex = {
      enable = true;
      customConf = true; # Opens port 3005 but doesn't use it?
    };

    firefox-syncserver = {
      enable = true;
      customConf = true;
    };

    jellyfin = {
      enable = true;
      customConf = true;
    };

    searx = {
      enable = true;
      customConf = true;
    };

    syncthing = {
      enable = true;
      customConf = true;
    };

    wireguard = {
      enable = true;
      adguardhome.enable = true;
    };

    forgejo = {
      container.enable = true;
    };

    nextcloud = {
      container.enable = true;
    };

    prometheus = {
      enable = true;
      customConf = true;
    };
  };
}
