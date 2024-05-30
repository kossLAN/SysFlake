{
  lib,
  config,
  ...
}: let
  cfg = config.programs.syncthing;
in {
  options.programs.syncthing = {
    usermodeEnable = lib.mkEnableOption "syncthing";
  };

  # This is redundant please remove sometime please
  config = lib.mkIf cfg.usermodeEnable {
    home-manager.users.${config.users.defaultUser} = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
