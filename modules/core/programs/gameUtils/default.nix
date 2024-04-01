{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.programs.gameUtils;
in
{
  options.programs.gameUtils = {
    enable = lib.mkEnableOption "gameUtils";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };

      gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
      scanmem
    ];
  };
}
