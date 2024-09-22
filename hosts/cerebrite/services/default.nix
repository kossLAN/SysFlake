{...}: {
  virtualisation = {
    portainer = {
      enable = true;
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

    forgejo = {
      container.enable = true;
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
  };
}
