{
  config,
  lib,
  ...
}: let
  cfg = config.services.tablet;
in {
  options.services.tablet = {
    enable = lib.mkEnableOption "tablet";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
        blacklistedKernelModules = ["wacom"];
      };
    };
  };
}
