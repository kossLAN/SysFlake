{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.steam;
in {
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        scanmem
        protonup-qt
        wine
        winetricks
      ];
    };

    programs = {
      steam = {
        remotePlay.openFirewall = true;
        extest.enable = true;
        protontricks.enable = true;
      };

      gamemode.enable = true;
    };
  };
}
