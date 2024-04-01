{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.programs.hm.art;
in
{
  options.programs.hm.art = {
    enable = lib.mkEnableOption "art";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      home.packages = with pkgs; [
        blender-hip
        kicad
        gimp
      ];
    };
  };
}
