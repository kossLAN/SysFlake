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
    darwinModules = import ./modules/darwin;

    # NixOS Configurations
    nixosConfigurations = {
      galahad = libx.mkHost {
        hostname = "galahad";
        desktop = "hyprland";
        username = "koss";
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
  };

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

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
