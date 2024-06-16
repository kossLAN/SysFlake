{
  inputs,
  outputs,
  nix-darwin,
  stateVersion,
  username,
  ...
}: {
  # Helper function for generating host configs
  mkHost = {
    hostname,
    platform ? "x86_64-linux",
    pkgsInput ? inputs.nixpkgs,
  }:
    pkgsInput.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs stateVersion username hostname platform;
      };
      modules = [../../hosts/${hostname}];
    };

  mkDarwin = {hostname}:
    nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs outputs stateVersion username hostname;
      };
      modules = [../../hosts/${hostname}];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
