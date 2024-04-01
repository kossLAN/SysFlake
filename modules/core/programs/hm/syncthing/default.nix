{ lib
, config
, ...
}:
let
  cfg = config.programs.hm.syncthing;
in
{
  options.prgorams.hm.syncthing = {
    enable = lib.mkEnableOption "syncthing";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
