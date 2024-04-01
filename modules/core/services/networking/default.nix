{
  config,
  lib,
  ...
}: let
  cfg = config.networking.nm;
in {
  options.networking.nm = {
    enable = lib.mkEnableOption "nm";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
    };

    users.users.${config.defaultUser}.extraGroups = [
      "networkmanager"
    ];
  };
}
