{ inputs
, outputs
, nix-darwin
, stateVersion
, username
, ...
}: {
  # Helper function for generating home-manager configs
  mkHome =
    { hostname
    , platform ? "desktop"
    , homeDir ? "/home/${username}"
    , user ? username
    , desktop ? null
    ,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs outputs stateVersion hostname desktop platform homeDir;
        username = user;
      };
      modules = [
        # As of now I only have one user, it will probably stay that way for obvious reasons...
        ../../home
      ];
    };

  # Helper function for generating host configs
  mkHost =
    { hostname
    , desktop ? null
    , pkgsInput ? inputs.nixpkgs
    , username ? username
    ,
    }:
    pkgsInput.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs stateVersion username hostname desktop;
      };
      modules = [ ../../hosts/${hostname} ];
    };

  mkDarwin =
    { hostname
    , platform ? "macbook"
    , homeDir ? "/Users/${username}"
    , user ? username
    ,
    }:
    nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs outputs stateVersion hostname platform;
        username = user;
      };
      modules = [
        ../../hosts/${hostname}
      ];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
