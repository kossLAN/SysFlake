{
  lib,
  config,
  ...
}: let
  cfg = config.services.helpfulUtils;
in {
  # Essentially just basic services I tend to use on all my linux installs.
  options.services.helpfulUtils = {
    enable = lib.mkEnableOption "helpfulUtils";
  };

  config = lib.mkIf cfg.enable {
    services = {
      blueman.enable = true;
      devmon.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      dbus.enable = true;
    };
  };
}
