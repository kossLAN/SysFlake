{
  outputs,
  inputs,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    outputs.universalModules
    outputs.darwinModules
    inputs.secrets.secretModules
  ];

  networking = {
    hostName = hostname;
  };

  homebrew = {
    enable = true;
    customConf = true;
  };

  programs = {
    customNeovim.enable = true;
    # vscodium.enable = true;
    syncthing.usermodeEnable = true;
    dev.git.enable = true;

    zsh = {
      enable = true;
      interactiveShellInit = ''
        alias nix-rebuild="darwin-rebuild --flake ~/.config/nix-darwin#bulbel switch"
      '';
      customConf = true;
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
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
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
    configurationRevision = outputs.rev or outputs.dirtyRev or null;
    stateVersion = 4;
  };
}
