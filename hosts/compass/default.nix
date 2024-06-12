{
  inputs,
  outputs,
  lib,
  config,
  hostname,
  username,
  stateVersion,
  ...
}: {
  imports = [
    outputs.universalModules
    outputs.nixosModules
    inputs.jovian.nixosModules
    ./disk-config.nix
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 1d";

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # Internationalisation and Timezone
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Boot
  boot = {
    # Bootloader
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    loader.grub = {
      efiSupport = true;
      enable = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/zsh";
    };

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
    hostName = hostname;
  };

  theme.oled.enable = true;

  services = {
    bluetooth.enable = true;
    ssh.enable = true;
    amdGpu.enable = true;
    sound.enable = true;
  };

  programs = {
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

    foot = {
      enable = true;
      customConf = true;
    };

    dev = {
      git.enable = true;
    };

    game = {
      utils.enable = true; # Misc game programs
      mangohud.enable = true;
    };

    jovian = {
      steam = {
        enable = true;
      };
    };
  };

  system.stateVersion = stateVersion;
}
