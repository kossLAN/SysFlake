{
  description = "Main nix configuration";

  outputs = inputs @ {
    self,
    nixpkgs,
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

      # Framework Laptop
      bulbel = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/nixos
          ./hosts/bulbel
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

      # Home server
      cerebrite = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/server
          ./hosts/cerebrite
        ];
      };

      # Routing VPS
      dahlia = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/universal
          ./modules/server
          ./hosts/dahlia
        ];
      };
    };
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    custom-neovim = {
      url = "git+https://git.kosslan.dev/kossLAN/NvimFlake?ref=master";
    };

    # Secrets 🤫
    agenix.url = "github:ryantm/agenix";

    # Package Flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland Window Manager
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    # Cosmic DE Test
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Audio screensharing in firefox
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };
}
