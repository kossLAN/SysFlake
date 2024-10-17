{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.obs-studio;
in {
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
