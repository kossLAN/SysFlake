{config, ...}: {
  virtualisation = {
    portainer = {
      enable = true;
      reverseProxy.enable = true;
    };
  };

  users = {
    groups.storage = {
      name = "storage";
      members = [
        "syncthing"
      ];
      gid = 8000;
    };
  };

  services = {
    ssh = {
      enable = true;
    };

    caddy = {
      enable = true;
      email = "kosslan@kosslan.dev";
    };

    # Private Services
    syncthing = {
      enable = true;
      group = "storage";
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = true;
      overrideFolders = false;
      overrideDevices = false;
    };

    prometheus = {
      enable = true;
      defaults.enable = true;
    };

    # Public Services
    # TODO: Switch to caddy
    firefox-syncserver = {
      enable = true;
      secrets = config.age.secrets.firefox.path;
      defaults.enable = true;
      reverseProxy.enable = true;
    };

    forgejo = {
      container.enable = true;
      reverseProxy.enable = true;
    };

    searx = {
      enable = true;
      defaults.enable = true;
      reverseProxy.enable = true;
    };
  };
}
