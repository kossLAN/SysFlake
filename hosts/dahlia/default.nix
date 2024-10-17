{...}: {
  imports = [
    ./services
    ./programs
    ./hardware
    ./networking
    ./secrets
  ];

  networking.hostName = "dahlia";

  # boot.loader = {
  #   systemd-boot.enable = true;
  #   efi.canTouchEfiVariables = true;
  # };

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = false;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    defaults.enable = true;
    stateVersion = "24.05";
  };
}
