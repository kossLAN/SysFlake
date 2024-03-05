{ inputs, outputs, config, lib, pkgs, stateVersion, hostname, homeDir, platform, ... }:
{
  imports = [ ./programs ];

  networking = {
    hostName = "bulbel";
  };

  # programs.bash.enable = true;
  programs = {
    zsh = {
      enable = true;
      interactiveShellInit = ''
        alias nix-rebuild="darwin-rebuild --flake /Users/koss/.config/nix-darwin switch"
      '';
    };
  };

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

  users.users.koss = {
    home = "/Users/koss";
    name = "koss";
  };
}
