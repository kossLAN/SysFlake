{config, ...}: {
  jovian = {
    hardware.has.amd.gpu = true;
    steamos.useSteamOSConfig = true;

    devices = {
      steamdeck = {
        enable = true;
        autoUpdate = false;
        enableGyroDsuService = true;
      };
    };

    steam = {
      enable = true;
      user = config.users.defaultUser;

      # I couldn't get this to work, so I'll just use SDDM to switch
      autoStart = true;
      desktopSession = "plasma";
    };

    # I couldn't get this to work either, probably also broken on latest release
    decky-loader = {
      enable = true;
    };
  };

  # loginmanager.greetd.tuigreet.enable = true;

  services = {
    ssh.enable = true;
    desktopManager.plasma6.enable = true;
    tailscale.enable = true;

    xserver = {
      enable = true;
    };
  };
}
