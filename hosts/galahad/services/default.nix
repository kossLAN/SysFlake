{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  virt = {
    # docker.enable = true;
    qemu.enable = true;
  };

  networking = {
    networkmanager.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    ssh.enable = true;
    amdGpu.enable = true;
    helpfulUtils.enable = true;
    sound.enable = true;
    tailscale.enable = true;

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

    # desktopManager = {
    #   plasma6.enable = true;
    #   cosmic.enable = true;
    # };

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
