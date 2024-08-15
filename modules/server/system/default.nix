{
  self,
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrs mapAttrsToList;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.system;
in {
  options.system = {
    defaults = {
      enable = mkEnableOption "My opionated system config";
      user = mkOption {
        type = lib.types.str;
        default = "koss";
      };
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
      gc.options = "--delete-older-than 14d";

      settings = {
        experimental-features = "nix-command flakes";
        warn-dirty = false;
        keep-outputs = true;
        keep-derivations = true;
        auto-optimise-store = true;
        trusted-users = [cfg.defaults.user];

        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };
    # Nixpkgs settings - for now I only own x86 computers running nixos for personal use, however this will
    # need to change when I get some arm systems
    nixpkgs = {
      overlays = [
        self.overlays.additions # Additional Packages
        self.overlays.modifications # Modified Packages
        self.overlays.stable-packages # Stable Nixpkgs
      ];
      config = {
        allowUnfree = true;
      };
    };

    networking.firewall.enable = true; # Enabled by default, but it makes me feel better knowing its here for sure
  };
}
