{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.loginmanager.greetd.tuigreet;
in {
  options.loginmanager.greetd.tuigreet = {
    enable = mkEnableOption "Simple greeter to use for fast setup";
    # session = mkOption {
    #   type = lib.types.str;
    #   default = "none+i3";
    # };
  };

  config = mkIf cfg.enable {
    services = {
      xserver.displayManager.startx.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r -g 'Welcome to my shite system'";
            user = "koss";
          };
        };
      };
    };
  };
}
