{...}: {
  imports = [
    ./services
    ./programs
    ./networking
    ./hardware
    ./arr
    ./secrets
  ];

  networking.hostName = "petrolea";

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = false;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    defaults.enable = true;
    stateVersion = "24.05";
  };
}
