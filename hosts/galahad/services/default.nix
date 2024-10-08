{pkgs, ...}: {
  networking = {
    networkmanager.enable = true;
  };

  hardware = {
    opentabletdriver.enable = true;
  };

  display.amd.enable = true;

  services = {
    ssh.enable = true;
    common.enable = true;
    sound.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
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
