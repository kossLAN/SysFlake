{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.gameUtils;
in {
  options.programs.gameUtils = {
    enable = lib.mkEnableOption "gameUtils";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        extest.enable = true;

        # package = pkgs.steam.override {
        #   extraEnv = {
        #     SDL_VIDEODRIVER = "x11";
        #   };
        # };
      };

      gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
      scanmem
    ];
  };
}
