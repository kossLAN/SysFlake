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

  # This is redundant please remove sometime please
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
