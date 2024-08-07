{inputs, ...}: {
  imports = [
    ./services
    ./programs
    ./networking
    ./hardware
    ./secrets

    inputs.secrets.secretModules
  ];

  networking.hostName = "petrolea";

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = false;
    };
  };

  system = {
    defaults.enable = true;
    stateVersion = "24.05";
  };
}
