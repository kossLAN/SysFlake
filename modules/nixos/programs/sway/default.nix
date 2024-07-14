{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.sway.defaults;
in {
  options.programs.sway.defaults = {
    enable = mkEnableOption "Sway configuration and shit :p";
  };

  config = mkIf cfg.enable {
    # XDG Portal Nonsense
    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];

      config.sway.default = [
        "wlr"
        "kde"
      ];
    };

    home-manager.users.${config.users.defaultUser} = {
      wayland.windowManager.sway = {
        enable = true;
        swaynag.enable = true;

        config = let
          modifier = "Mod4";
          left = "h";
          down = "j";
          up = "k";
          right = "l";
        in {
          # Displays TODO: make this a passthrough option on the module
          output = {
            DP-2 = {
              mode = "3840x2160@240.084Hz";
              scale = "1.25";
              # bg = "~/path/to/background.png fill";
            };
          };

          # Bars
          bars = [
            {
              position = "top";
              statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";

              colors = {
                statusline = "#ffffff";
                background = "#323232";
                inactiveWorkspace = {
                  background = "#32323200";
                  border = "#32323200";
                  text = "#5c5c5c";
                };
              };
            }
          ];

          # Keybinds
          modifier = modifier;
          keybindings = {
            # Program Launch Keybinds
            "${modifier}+Return" = "exec foot";
            "${modifier}+b" = "exec firefox-esr";
            "${modifier}+r" = "exec dolphin";
            "${modifier}+space" = "exec dmenu_path | wmenu | xargs swaymsg exec --";

            # Navigation
            "${modifier}+${left}" = "focus left";
            "${modifier}+${down}" = "focus down";
            "${modifier}+${up}" = "focus up";
            "${modifier}+${right}" = "focus right";
            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            # Switch to workspace
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            # Move focused container to workspace
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            # Window Management
            "${modifier}+Shift+b" = "splith";
            "${modifier}+Shift+v" = "splitv";
            "${modifier}+Shift+${left}" = "move left";
            "${modifier}+Shift+${down}" = "move down";
            "${modifier}+Shift+${up}" = "move up";
            "${modifier}+Shift+${right}" = "move right";
            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            # Quick Actions/Management
            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";
            "${modifier}+Shift+s" = "layout stacking";
            "${modifier}+Shift+w" = "layout tabbed";
            "${modifier}+Shift+e" = "layout toggle split";
            "${modifier}+f" = "fullscreen";
            "${modifier}+s" = "floating toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+Shift+space" = "focus mode_toggle";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+m" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
          };
        };
      };
    };
  };
}
