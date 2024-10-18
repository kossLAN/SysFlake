{pkgs, ...}: {
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
    ssh.enable = true;
    forgejo.container.enable = true;

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

    netdata = {
      enable = true;

      package = pkgs.netdata.override {
        withCloudUi = true;
      };

      python = {
        enable = true;
        recommendedPythonPackages = true;
      };
    };
  };
}
