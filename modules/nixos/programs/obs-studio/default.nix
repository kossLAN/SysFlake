{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.obs-studio;
in {
  options.programs.obs-studio = {
    enable = lib.mkEnableOption "obs-studio";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vkcapture
        ];
      };
    };
  };
}
