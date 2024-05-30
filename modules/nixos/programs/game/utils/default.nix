{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.game.utils;
in {
  options.programs.game.utils = {
    enable = lib.mkEnableOption "game";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        radeontop
        btop
        lutris
        prismlauncher
        gamemode
        protonup-qt
        #heroic
        #rpcs3
        protontricks
        wine
        winetricks
        xivlauncher
        r2modman
        osu-lazer-bin
      ];
    };
  };
}
