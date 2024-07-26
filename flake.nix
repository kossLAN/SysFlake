{
  description = "Main nix configuration";

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    ...
  }: {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # Main desktop
      galahad = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {inherit self system inputs;};

        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/galahad
        ];
      };

      # OVH Server
      cerebrite = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {inherit self system inputs;};
        modules = [
          ./modules/universal
          ./modules/server
          ./hosts/cerebrite
        ];
      };

      # Steamdeck
      compass = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {inherit self system inputs;};
        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/compass
        ];
      };

      # MacBook (NixOS Counterpart)
      lily = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {inherit self system inputs;};
        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/lily
        ];
      };

      # VPS Testing
      dahlia = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {inherit self system inputs;};
        modules = [
          ./modules/universal
          ./modules/server
          ./hosts/dahlia
        ];
      };
    };

    # M1 Max on MacOS
    bulbel = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
      };
      modules = [
        ./modules/universal
        ./modules/darwin
        ./hosts/bulbel
      ];
    };
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Secrets 🤫 - TODO: Switch to agenix/or a better alternative
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
