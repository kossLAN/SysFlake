{
  lib,
  config,
  inputs,
  outputs,
  stateVersion,
  hostname,
  username,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrs mapAttrsToList;

  cfg = config.system;
in {
  options.system = {
    defaults.enable = lib.mkEnableOption "My opionated system config";

    defaults.grub.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.system.defaults.enable && !config.system.defaults.systemd-boot.enable;
    };

    defaults.systemd-boot.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.defaults.enable {
    # Locale - This is obviously going to be the same for ne cross system
    # tired of wasted space declaring this shit everytime.
    time.timeZone = "America/New_York";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
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
    };

    # Common Nix Settings, registry thing is specifically for flakes, don't really remember where I got
    # it from, however I definitely didnt write it and couldn't tell you exactly how it works.
    nix = {
      registry = mapAttrs (_: value: {flake = value;}) inputs;
      nixPath = mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      optimise.automatic = true;
      gc.automatic = true;
      gc.options = "--delete-older-than 1d";

      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [username];
      };
    };

    # Nixpkgs settings - for now I only own x86 computers running nixos for personal use, however this will
    # need to change when I get some arm systems
    nixpkgs = {
      hostPlatform = "x86_64-linux";
      overlays = [
        outputs.overlays.additions # Additional Packages
        outputs.overlays.modifications # Modified Packages
      ];
      config = {
        allowUnfree = true;
      };
    };

    # Boot Settings - yes I use grub, fuck you
    boot = {
      loader.efi = {
        canTouchEfiVariables = true;
      };

      loader.grub = mkIf cfg.defaults.grub.enable {
        efiSupport = true;
        enable = true;
        device = "nodev";
        useOSProber = false;
      };

      loader.systemd-boot.enable = cfg.defaults.systemd-boot.enable;
    };

    # Just setting hostname
    networking.hostName = hostname;

    system.stateVersion = stateVersion;
  };
}
