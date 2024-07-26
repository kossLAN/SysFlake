{...}: {
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

  theme.oled = {
    enable = true;
    cursorSize = 26;
  };

  networking.hostName = "galahad";
  system = {
    defaults.enable = true;
    system.stateVersion = "23.11";
  };
}
