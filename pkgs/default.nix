{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  ida-free = pkgs.callPackage ./ida-free { };
}
