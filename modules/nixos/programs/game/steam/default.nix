{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.game.steam;
in {
  options.programs.game.steam = {
    enable = mkEnableOption "gameUtils";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        scanmem
      ];
    };

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        extest.enable = true;
        protontricks.enable = true;
      };

      gamemode.enable = true;
    };
  };
}
