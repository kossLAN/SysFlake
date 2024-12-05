{pkgs, ...}: {
  networking = {
    networkmanager.enable = true;
  };

  hardware = {
    opentabletdriver.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  display.amd.enable = true;

  services = {
    ssh.enable = true;
    common.enable = true;
    syncthing.enable = true;

    sound = {
      enable = true;
      lowLatency.enable = true;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    ollama = {
      enable = true;
      host = "0.0.0.0";
      acceleration = "rocm";
      rocmOverrideGfx = "10.3.0";
    };

    displayManager = {
      autoLogin = {
        enable = true;
        user = "koss";
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };

    udevRules = {
      enable = true;
      keyboard.enable = true;
    };
  };
}
