{config, ...}: {
  jovian = {
    hardware.has.amd.gpu = true;
    steamos.useSteamOSConfig = true;

    devices = {
      steamdeck = {
        enable = true;
        autoUpdate = true;
        enableGyroDsuService = true;
      };
    };

    steam = {
      enable = true;
      user = config.users.defaultUser;
      autoStart = true;
      desktopSession = "plasma";
    };

    decky-loader = {
      enable = true;
      user = config.users.defaultUser;
    };
  };

  # theme.oled.enable = true;

  services = {
    ssh.enable = true;

    displayManager.sddm.wayland.enable = true;
    xserver.desktopManager.plasma5.enable = true;
  };
}
