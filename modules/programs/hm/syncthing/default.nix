{
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.syncthing;
in {
  options.programs.hm.syncthing = {
    enable = lib.mkEnableOption "syncthing";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
