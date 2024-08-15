{
  imports = [
    ./boot
    ./hardware
    ./programs
    ./services
    ./secrets
  ];

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  theme.oled = {
    enable = true;
    cursorSize = 26;
  };

  networking.hostName = "galahad";

  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
