{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.syncthing;
in {
  options.programs.syncthing = {
    usermodeEnable = mkEnableOption "syncthing";
  };

  # This is redundant please remove sometime please
  config = mkIf cfg.usermodeEnable {
    home-manager.users.${config.users.defaultUser} = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
