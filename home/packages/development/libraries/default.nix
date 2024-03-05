{ pkgs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  # Really don't need most of this here, its really just bloat but I'm lazy :p
  home.packages = with pkgs; [
  ];
}
