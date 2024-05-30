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
    outputs.serverModules
    inputs.secrets.secretModules
    ./disk-config.nix
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
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
      trusted-users = [username];
    };
  };

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

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  networking = {
    hostName = hostname;
    firewall.enable = true;
  };

  programs = {
    utils.enable = true;
    customNeovim.enable = true;
    dev.git.enable = true;

    zsh = {
      enable = true;
      customConf = true;
    };

    nh = {
      enable = true;
      flake = ../..;
    };
  };

  virtualisation = {
    portainer.enable = true;
  };

  services = {
    ssh = {
      enable = true;
    };

    plex = {
      enable = true;
      customConf = true; # Opens port 3005 but doesn't use it?
    };

    jellyfin = {
      enable = true;
      customConf = true;
    };

    searx = {
      enable = true;
      customConf = true;
    };

    syncthing = {
      enable = true;
      customConf = true;
    };

    wireguard = {
      enable = true;
      adguardhome.enable = true;
    };

    forgejo = {
      container.enable = true;
    };

    nextcloud = {
      container.enable = true;
    };

    prometheus = {
      enable = true;
      customConf = true;
    };
  };

  system.stateVersion = stateVersion;
}
