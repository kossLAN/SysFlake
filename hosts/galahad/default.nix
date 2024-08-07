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
  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
