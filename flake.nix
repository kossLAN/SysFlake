{
  description = "Main nix configuration";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Package Flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

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
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS Configurations
    nixosConfigurations = {
      galahad = libx.mkHost {
        hostname = "galahad";
        desktop = "hyprland";
      };
    };

    # MacOS Configuration: this setups home-manager as well...
    darwinConfigurations = {
      bulbel = libx.mkDarwin {
        hostname = "bulbel";
        user = "koss";
        homeDir = "/Users/koss";
        platform = "macbook";
      };
    };

    # Home Manager
    homeConfigurations = {
      "${username}@galahad" = libx.mkHome {
        hostname = "galahad";
        desktop = "hyprland";
      };
    };
  };
}
