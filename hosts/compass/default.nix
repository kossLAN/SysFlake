{
  inputs,
  outputs,
  config,
  username,
  pkgs,
  ...
}: {
  imports = [
    outputs.universalModules
    outputs.nixosModules
    inputs.jovian.nixosModules.jovian
    ./hardware.nix
  ];

  system.defaults.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/zsh";
    };

    systemPackages = [pkgs.maliit-keyboard];

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
  };

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
    desktopManager.plasma6.enable = true;
  };

  programs = {
    utils.enable = true;
    customNeovim.enable = true;
    syncthing.usermodeEnable = true;
    vscodium.enable = true;

    nh = {
      enable = true;
      flake = "/home/${username}/.nixos-conf";
    };

    firefox = {
      enable = true;
      customPreferences = true;
      customExtensions = true;
      customPolicies = true;
      customSearchEngine = true;
    };

    zsh = {
      enable = true;
      customConf = true;
    };

    dev = {
      git.enable = true;
    };

    game = {
      utils.enable = true; # Misc game programs
      #mangohud.enable = true;
    };
  };
}
