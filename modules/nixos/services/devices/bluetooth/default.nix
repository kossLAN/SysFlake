{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.bluetooth;
in {
  # Just little abstraction since if I have bluetooth I'm going to
  # want it to start on boot.
  options.services.bluetooth = {
    enable = mkEnableOption "bluetooth";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
