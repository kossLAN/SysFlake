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
      galahad = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};

        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/galahad
        ];
      };

      # Steamdeck
      compass = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/compass
        ];
      };

      # MacBook (NixOS Counterpart)
      lily = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/lily
        ];
      };

      # Dedicated New York Based Server
      petrolea = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/server
          ./hosts/petrolea
        ];
      };

      # VPS Testing
      dahlia = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/server
          ./hosts/dahlia
        ];
      };
    };

    # M1 Max on MacOS
    darwinConfigurations = {
      bulbel = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/darwin
          ./hosts/bulbel
        ];
      };
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

    agenix.url = "github:ryantm/agenix";

    # Package Flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland WM
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    # MacOS Nix Modules
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # MacOS module to properly link mac apps
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };

    # App runner
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shell for window managers in QT
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Disk Management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Asahi Linux Stuff For M1 Macs
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
    };

    # Steamdeck Modules
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
