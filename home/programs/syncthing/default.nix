{ platform
,lib
,...
}:
let
  allowedPlatforms = [ "desktop" "macbook" ];
in
{
  services.syncthing = lib.mkIf (builtins.elem platform allowedPlatforms) {
    enable = true; 
  };
}
