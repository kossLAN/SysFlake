{
  config,
  lib,
  ...
}: let
  cfg = config.services.bluetooth;
in {
  # Just little abstraction since if I have bluetooth I'm going to
  # want it to start on boot.
  options.services.bluetooth = {
    enable = lib.mkEnableOption "bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
