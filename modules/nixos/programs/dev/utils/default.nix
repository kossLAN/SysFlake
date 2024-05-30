{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.dev.utils;
in {
  options.programs.dev.utils = {
    enable = lib.mkEnableOption "utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        gcc
        rustup
        zig
        zls
        gnumake42
        dpkg
        nodejs
        xxd
        gdb
        valgrind
        killall
        file
        dotnet-sdk
        man-pages
      ];
    };
  };
}
