{outputs, ...}: {
  imports = [
    ./system
    outputs.nixosModules
    outputs.universalModules
  ];

  system.defaults.enable = true;
  networking.nm.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_DRM_DEVICES = "/dev/dri/card0";
    };
  };

  loginmanager.greetd = {
    gtkgreet.enable = true;
  };

  theme.oled = {
    enable = true;
    cursorSize = 24;
  };
}
