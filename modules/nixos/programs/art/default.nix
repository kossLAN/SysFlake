{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.art;
in {
  options.programs.art = {
    enable = mkEnableOption "art";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        blender-hip
        gimp
      ];
    };
  };
}
