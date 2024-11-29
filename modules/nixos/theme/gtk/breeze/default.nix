{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.gtk.breeze;
in {
  options.theme.gtk.breeze = {
    enable = mkEnableOption "Enable Breeze GTK theme";
  };

  config = mkIf cfg.enable {
    theme.gtk = {
      enable = true;
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";

      icons = {
        name = "breeze-dark";
        package = pkgs.kdePackages.breeze-icons;
      };
    };
  };
}
