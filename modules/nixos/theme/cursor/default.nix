{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) package str int;

  cfg = config.theme.cursor;
in {
  imports = [./notwaita];

  options.theme.cursor = {
    enable = mkEnableOption "Cursor theme";

    package = mkOption {
      type = package;
    };

    name = mkOption {
      type = str;
      description = "Name of the theme package";
    };

    cursorSize = mkOption {
      type = int;
      default = 24;
    };
  };

  # TODO: add x11 options
  # This is just my best attempt at getting XCURSOR to work
  # without any form of home management.
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [cfg.package];

      variables = {
        XCURSOR_SIZE = mkForce cfg.cursorSize;
        XCURSOR_THEME = mkForce cfg.name;
        XCURSOR_PATH = mkForce [
          "$HOME/.icons"
          "$HOME/.local/share/icons"
          "${cfg.package}/share/icons"
        ];
      };

      etc = let
        gtkSettings = ''
          [Settings]
          gtk-cursor-theme-name=${cfg.name}
          gtk-cursor-theme-size=${toString cfg.cursorSize}
        '';
      in {
        "xdg/gtk-3.0/settings.ini" = {
          text = gtkSettings;
          mode = "444";
        };

        "xdg/gtk-4.0/settings.ini" = {
          text = gtkSettings;
          mode = "444";
        };
      };
    };

    programs.dconf = {
      enable = true;
      profiles.users.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              cursor-theme = "'${cfg.name}'";
              cursor-size = lib.gvariant.mkUint16 cfg.cursorSize;
            };
          };
        }
      ];
    };
  };
}
