{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./boot
    ./hardware
    ./programs
    ./services

    outputs.universalModules
    outputs.nixosModules
    inputs.secrets.secretModules
  ];

  system.defaults.enable = true;

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking.nm.enable = true;

  theme.oled = {
    enable = true;
    cursorSize = 26;
  };
}
