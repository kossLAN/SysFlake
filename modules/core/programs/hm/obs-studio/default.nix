{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.programs.hm.obs-studio;
in
{
  options.programs.hm.obs-studio = {
    enable = lib.mkEnableOption "obs-studio";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
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
