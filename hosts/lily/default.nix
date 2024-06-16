{outputs, ...}: {
  imports = [
    ./system
    outputs.nixosModules
    outputs.universalModules
  ];

  system.defaults.enable = true;
  networking.nm.enable = true;

  loginmanager.greetd = {
    gtkgreet.enable = true;
  };

  theme.oled = {
    enable = true;
    cursorSize = 28;
  };
}
