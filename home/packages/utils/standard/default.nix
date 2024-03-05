{ pkgs
, platform
, lib
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs;
    [
      ngrok
      openconnect
      fastfetch
      ddcutil
      unzip
    ];
}
