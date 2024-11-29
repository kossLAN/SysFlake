{
  self,
  pkgs,
  lib,
  config,
  inputs,
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

    # System-wide font configuration
    fonts = {
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        })
      ];

      fontconfig = {
        defaultFonts = {
          monospace = ["JetBrainsMono"];
        };
      };
    };

    # Some necessary session variables that I need, especially since I no longer use
    # home-manager.
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    # Common Nix Settings, registry thing is specifically for flakes, don't really remember where I got
    # it from, however I definitely didnt write it and couldn't tell you exactly how it works.
    nix = {
      registry = lib.mkForce (mapAttrs (_: value: {flake = value;}) inputs);
      nixPath = lib.mkForce (mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry);
      optimise.automatic = true;

      gc = {
        automatic = true;
        options = "--delete-older-than 14d";
      };

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
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };

    # Nixpkgs settings - for now I only own x86 computers running nixos for personal use, however this will
    # need to change when I get some arm systems
    nixpkgs = {
      overlays = [
        self.overlays.additions # Additional Packages
        self.overlays.modifications # Modified Packages
        inputs.custom-neovim.overlays.default # Neovim Custom Configuration
        inputs.custom-zsh.overlays.default # Zsh Custom Configuration
      ];
      config = {
        allowUnfree = true;
      };
    };
  };
}
