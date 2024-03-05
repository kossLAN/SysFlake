{ pkgs
, inputs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" "macbook" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs; [
    gcc
    rustup
    zig
    zls
    gnumake42
    dpkg
    #ida-free
    nodejs
    xxd
    #gdb
    killall
    file
    #dotnetPackages.Nuget
    dotnet-sdk
    man-pages
    #inputs.nix-alien.packages.${pkgs.system}.default
  ];
}
