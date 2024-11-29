{
  imports = [
    ./boot
    ./hardware
    ./programs
    ./services
  ];

  networking.hostName = "bulbel";
  nixpkgs.hostPlatform = "x86_64-linux";

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
