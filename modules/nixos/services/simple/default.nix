{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.helpfulUtils;
in {
  # Essentially just basic services I tend to use on all my linux installs.
  options.services.helpfulUtils = {
    enable = mkEnableOption "helpfulUtils";
  };

  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
      devmon.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      dbus.enable = true;
    };
  };
}
