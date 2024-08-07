{...}: {
  # This is a long list of things I have enabled on this server
  # It's a dedicated box so thats mostly the reason, but potentially
  # would be better off with a few more boxes idk
  virtualisation = {
    portainer = {
      enable = true;
      reverseProxy.enable = true;
    };
  };

  users = {
    groups."storage" = {
      name = "storage";
      members = ["syncthing"];
      gid = 8000;
    };
  };

  services = {
    ssh = {
      enable = true;
    };

    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = true;
      overrideFolders = false;
      overrideDevices = false;
    };
  };
}
