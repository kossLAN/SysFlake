{config, ...}: {
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

  services = let
    user = config.users.defaultUser;
    group = "users";
    dataDir = "/home/${user}/.config";
  in {
    ssh = {
      enable = true;
    };

    # plex = {
    #   enable = true;
    #   user = user;
    #   group = group;
    #   openFirewall = true;
    # };

    firefox-syncserver = {
      enable = true;
      secrets = config.age.secrets.firefox.path;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    jellyfin = {
      enable = true;
      user = user;
      group = group;
      dataDir = "${dataDir}/jellyfin";
      defaults.enable = true;
      reverseProxy.enable = true;
    };
    #
    # arr = {
    #   enable = true;
    #   user = user;
    #   group = group;
    #   dataDir = dataDir;
    #   lidarrApiKey = config.age.secrets.lidarr.path;
    #
    #   reverseProxy = {
    #     enable = true;
    #     domain = "kosslan.dev";
    #   };
    # };

    # Route via VPN in networking
    deluge = {
      container = {
        enable = true;
        authFile = config.age.secrets.deluge.path;
      };
    };

    searx = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    syncthing = {
      enable = true;
      user = user;
      group = group;
      dataDir = "/home/${user}/";
      overrideFolders = false;
      overrideDevices = false;
    };

    nextcloud = {
      container.enable = true;
      reverseProxy.enable = true;
    };

    forgejo = {
      container.enable = true;
      reverseProxy.enable = true;
    };

    prometheus = {
      enable = true;
      defaults.enable = true;
    };
  };
}
