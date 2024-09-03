{
  inputs,
  pkgs,
  ...
}: { 
  networking = {
    hostName = "bulbel";
  };

  homebrew = {
    enable = true;
    defaults.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nvim-pkg 
    rustup
  ];

  programs = { 
    syncthing.user.enable = true;
    dev.git.enable = true;

    zsh = {
      enable = true;
      interactiveShellInit = ''
        alias nix-rebuild="darwin-rebuild --flake ~/.config/nix-darwin#bulbel switch"
      '';
      defaults.enable = true;
    };

    utils = {
      enable = true;
      trampoline.enable = true;
    };

    ssh = {
      importConfig = true;
      importKeys = true;
    };

    # Wait for https://github.com/LnL7/nix-darwin/pull/942 merges
    # nh = {
    #   enable = true;
    #   flake = ../..;
    # };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  services = {
    nix-daemon.enable = true;
    tailscale.enable = true;
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [
      inputs.custom-neovim.overlays.default # Neovim Custom Configuration
    ];
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    gc = { 
      automatic = true;
      options = "--delete-older-than 1d";
    };
  };

  system = {
    stateVersion = 4;
  };
}
