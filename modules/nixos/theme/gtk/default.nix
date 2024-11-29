{
  config,
  lib,
  ...
}: let
  inherit (lib.types) str package;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.gtk;
in {
  imports = [
    ./breeze
  ];

  options.theme.gtk = {
    enable = mkEnableOption "Enable GTK Theming";

    package = mkOption {
      type = package;
    };

    name = mkOption {
      type = str;
    };

    icons = {
      name = mkOption {
        type = str;
      };

      package = mkOption {
        type = package;
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [cfg.package];

      sessionVariables = {
        GTK_THEME = cfg.name;
      };
    };

    # Redundancy, I'm pretty sure the environment variable is all you need.
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true; # prevents overriding
          settings = {
            "org/gnome/desktop/interface" = {
              gtk-theme = cfg.name;
              icon-theme = cfg.icons.name;
            };
          };
        }
      ];
    };
  };
}
