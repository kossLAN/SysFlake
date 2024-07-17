{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.dev.utils;
in {
  options.programs.dev.utils = {
    enable = mkEnableOption "utils";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        zls
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
