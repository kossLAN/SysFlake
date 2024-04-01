{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.udevRules;
in {
  options.services.udevRules = {
    enable = lib.mkEnableOption "udevRules";
    keyboard.enable = lib.mkEnableOption "keyboard";
  };

  config = lib.mkIf cfg.enable {
    services = lib.mkIf cfg.keyboard.enable {
      udev = {
        packages = with pkgs; [
          via
        ];
      };
    };
  };
}
