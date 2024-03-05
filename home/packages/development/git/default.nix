{ lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" "macbook" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  programs.git = {
    enable = true;
    userName = "kossLAN";
    userEmail = "kosslan@kosslan.dev";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" "https://github.example.com" ];
    };
  };
}

