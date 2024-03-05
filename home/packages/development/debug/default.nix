{ pkgs
, inputs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs; [
    valgrind
    ghidra
    ida-free
    gdb
  ];
}
