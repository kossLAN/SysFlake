{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    outputs.universalModules
    outputs.darwinModules
  ];

  networking = {
    hostName = "bulbel";
  };

  homebrew = {
    enable = true;
    customConf = true;
  };

  programs = {
    zsh = {
      enable = true;
      interactiveShellInit = ''
        alias nix-rebuild="darwin-rebuild --flake ~/.config/nix-darwin#bulbel switch"
      '';
      customConf = true;
    };

    hm = {
      nvim.enable = true;
      #vscodium.enable = true;
      syncthing.enable = true;

      dev = {
        git.enable = true;
      };

      utils = {
        enable = true;
        trampoline.enable = true;
      };
    };
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
}
