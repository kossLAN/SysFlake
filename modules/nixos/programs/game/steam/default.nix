{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.game.steam;
in {
  options.programs.game.steam = {
    enable = lib.mkEnableOption "gameUtils";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        extest.enable = true;
      };

      gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
      scanmem
    ];
  };
}
