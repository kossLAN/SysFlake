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

    custom-neovim = {
      url = "git+ssh://git@git.kosslan.dev/kossLAN/NvimFlake?ref=master";
    };

    # Secrets 🤫
    agenix.url = "github:ryantm/agenix";

    # Package Flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Steamdeck Modules
    jovian = {
      url = "github:Jovian-Experiments/Jovian-Nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
