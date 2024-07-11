{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./system
    outputs.universalModules
    outputs.nixosModules
    inputs.secrets.secretModules
  ];

  system.defaults.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
    };

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking.nm.enable = true;

  loginmanager.greetd = {
    gtkgreet.enable = true;
  };

  theme.oled = {
    enable = true;
    cursorSize = 24;
  };
}
