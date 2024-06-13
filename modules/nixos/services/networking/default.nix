{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.networking.nm;
in {
  options.networking.nm = {
    enable = mkEnableOption "nm";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
    };

    users.users.${config.users.defaultUser}.extraGroups = [
      "networkmanager"
    ];
  };
}
