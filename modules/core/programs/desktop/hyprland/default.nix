{
  lib,
  config,
  ...
}: let
  cfg = config.programs.hyprland;
in {
  options.programs.hyprland = {
    customConf.enable = lib.mkEnableOption "hyprland config";
  };

  config = lib.mkIf cfg.enable {
    #TODO: move hpyrland configuration into this.
  };
}
