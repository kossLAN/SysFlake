{ pkgs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
    ];
  };
}
