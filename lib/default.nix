{ inputs
, outputs
, nix-darwin
, stateVersion
, username
, ...
}:
let
  helpers = import ./helpers { inherit inputs outputs nix-darwin stateVersion username; };
in
{
  inherit (helpers) mkHome mkHost mkDarwin forAllSystems;
}
