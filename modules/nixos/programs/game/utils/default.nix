{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.game.utils;
in {
  options.programs.game.utils = {
    enable = mkEnableOption "game";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        radeontop
        btop
        lutris
        prismlauncher
        gamemode
        protonup-qt
        wine
        winetricks
        r2modman
        osu-lazer-bin
      ];
    };
  };
}
