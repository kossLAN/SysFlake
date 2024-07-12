{
  description = "Main nix configuration";

  outputs = {
    self,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    stateVersion = "23.11";
    username = "koss";
    libx = import ./lib {inherit inputs outputs nix-darwin stateVersion username;};
  in {
    # Packages & Overlays
    overlays = import ./overlays {inherit inputs;};
    universalModules = import ./modules/universal;
    nixosModules = import ./modules/nixos;
    serverModules = import ./modules/server;
    darwinModules = import ./modules/darwin;

    # NixOS Configurations
    nixosConfigurations = {
      # Main desktop
      galahad = libx.mkHost {
        hostname = "galahad";
      };

      # OVH Server
      cerebrite = libx.mkHost {
        hostname = "cerebrite";
      };

      # Steamdeck
      compass = libx.mkHost {
        hostname = "compass";
      };

      # MacBook (NixOS Counterpart)
      lily = libx.mkHost {
        hostname = "lily";
        platform = "aarch64-linux";
      };
    };

    # MacOS Configuration: this setups home-manager as well...
    darwinConfigurations = {
      # Laptop
      bulbel = libx.mkDarwin {
        hostname = "bulbel";
      };
    };
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Secrets 🤫
    secrets = {
      url = "git+ssh://git@git.kosslan.dev/kossLAN/SecretFlake?ref=master";
    };

    # Package Flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-Nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Testing Cosmic DE
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
