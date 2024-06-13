{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.obs-studio;
in {
  options.programs.obs-studio = {
    enable = mkEnableOption "obs-studio";
  };
  config = mkIf cfg.enable {
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
