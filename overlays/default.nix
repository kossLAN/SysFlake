# This file defines overlays
{inputs, ...}: let
  imagedir = ./assets;
in {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # steam = prev.steam.override ({ extraPkgs ? pkgs': [ ], ... }: {
    #   extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
    #     v8
    #   ]);
    # });
  };

  # Allows me to use stable packages where I need them.
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  unstable-packages = final: _prev: {
    stable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
