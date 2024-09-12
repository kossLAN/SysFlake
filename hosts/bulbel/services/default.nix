{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nixos-cosmic.nixosModules.default];

  virt = {
    docker.enable = true;
  };

  networking = {
    networkmanager.enable = true;
  };

  hardware = {
    system76.enableAll = true;
  };

  services = {
    ssh.enable = true;
    amdGpu.enable = true;
    helpfulUtils.enable = true;
    sound.enable = true;
    tailscale.enable = true;

    desktopManager = {
      cosmic.enable = true;
    };

    displayManager = {
      cosmic-greeter.enable = true;
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
