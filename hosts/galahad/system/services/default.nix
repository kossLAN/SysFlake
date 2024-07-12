{
  # pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  virt = {
    docker.enable = true;
    qemu.enable = true;
  };

  networking.networkmanager.enable = true;

  services = {
    tablet.enable = true;
    bluetooth.enable = true;
    ssh.enable = true;
    amdGpu.enable = true;
    helpfulUtils.enable = true;
    sound.enable = true;

    # displayManager.cosmic-greeter.enable = true;

    # desktopManager = {
    #   plasma6.enable = true;
    #   cosmic.enable = true;
    # };

    # printing = {
    #   enable = true;
    #   drivers = [pkgs.hplipWithPlugin];
    # };

    udevRules = {
      enable = true;
      keyboard.enable = true;
    };
  };
}
