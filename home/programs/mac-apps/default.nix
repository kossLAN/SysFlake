{ pkgs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "macbook" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs; [
    iterm2
    spotify
    discord
    # fastfetch
    gimp
    # glfw
    # glm
  ];
}
