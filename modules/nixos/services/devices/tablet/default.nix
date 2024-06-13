{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.tablet;
in {
  options.services.tablet = {
    enable = mkEnableOption "tablet";
  };

  config = mkIf cfg.enable {
    hardware = {
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
        blacklistedKernelModules = ["wacom"];
      };
    };
  };
}
