{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) nullOr path;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;

  cfg = config.programs.waybar;
  format = pkgs.formats.json {};
in {
  imports = [./config.nix];

  options.programs.waybar = {
    settings = mkOption {
      type = format.type;
      default = {};
    };

    style = mkOption {
      type = nullOr path;
    };
  };

  config = mkIf cfg.enable {
    # For MPRIS
    services.playerctld.enable = true;

    users.users.${config.users.defaultUser}.file = {
      ".config/waybar/config".source = format.generate "config" cfg.settings;
      ".config/waybar/style.css".source = cfg.style;
    };
  };
}
