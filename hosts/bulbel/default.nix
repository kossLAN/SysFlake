{
  imports = [
    ./boot
    ./hardware
    ./programs
    ./services
  ];

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking.hostName = "bulbel";

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.laptop = {
    enable = true;
    amd.enable = true;
  };

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
