{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.programs.hm.dev.utils;
in
{
  options.programs.hm.dev.utils = {
    enable = lib.mkEnableOption "utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      home.packages = with pkgs; [
        gcc
        rustup
        zig
        zls
        gnumake42
        dpkg
        nodejs
        xxd
        #gdb
        killall
        file
        dotnet-sdk
        man-pages
      ];
    };
  };
}
