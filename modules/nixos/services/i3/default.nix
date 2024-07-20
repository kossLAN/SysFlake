{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.xserver.windowManager.i3;
in {
  options.services.xserver.windowManager.i3 = let
    startupModule = lib.types.submodule {
      options = {
        command = mkOption {
          type = lib.types.str;
          description = "Command that will be executed on startup.";
        };

        always = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to run command on each i3 restart.";
        };

        notification = mkOption {
          type = lib.types.bool;
          default = true;
        };

        workspace = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    };

    criteriaModule = lib.types.attrsOf (lib.types.either lib.types.str lib.types.bool);
  in {
    defaults = {
      enable = mkEnableOption "Opinionated i3 WM Defaults";
      addtional = {
        dpi = mkOption {
          type = lib.types.nullOr lib.types.int;
          default = 120;
        };

        startup = mkOption {
          type = lib.types.listOf startupModule;
          default = [];
        };

        assigns = mkOption {
          type = lib.types.attrsOf (lib.types.listOf criteriaModule);
          default = {};
        };
      };
    };
  };

  config = mkIf cfg.defaults.enable {
    environment = {
      sessionVariables = {
        "QT_QPA_PLATFORM" = "xcb";
      };

      pathsToLink = ["/libexec"];
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
      config.common.default = [
        "kde"
      ];
    };

    programs = {
      nm-applet.enable = true;
      kitty = {
        enable = true;
        defaults.enable = true;
      };
    };

    services = {
      libinput = {
        enable = true;

        mouse = {
          accelProfile = "flat";
        };
      };

      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = config.users.defaultUser;
        };
      };

      xserver = {
        enable = true;
        dpi = cfg.defaults.addtional.dpi;
        desktopManager.xterm.enable = true;
        displayManager.lightdm.enable = true;

        windowManager.i3 = {
          extraPackages = with pkgs; [
            dmenu #application launcher most people use
            i3status # gives you the default i3 status bar
            # i3lock #default i3 screen locker
            # i3blocks #if you are planning on using i3blocks over i3status
          ];
        };
      };
    };

    home-manager.users.${config.users.defaultUser} = {
      # Make this an option
      home.file.".background-image".source = ./wallpapers/old.png;

      xsession.windowManager.i3 = {
        enable = true;

        config = let
          modifier = "Mod4";
          left = "h";
          down = "j";
          up = "k";
          right = "l";
        in {
          # Default Workspace
          defaultWorkspace = "workspace number 1";

          # Startup
          # TODO: fix assigns, see trace when building
          startup =
            [
              {
                always = true;
                command = "blueman-applet";
              }
              {
                always = true;
                command = "nm-applet";
              }
              {
                always = true;
                command = "nohup ${pkgs.flameshot}/bin/flameshot &";
              }
              {
                always = true;
                command = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
                notification = false;
              }
            ]
            ++ cfg.defaults.addtional.startup;

          assigns = cfg.defaults.addtional.assigns;

          # Bars
          bars = [
            {
              position = "top";
              statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
              trayOutput = "primary";

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
            "${modifier}+Return" = "exec kitty";
            "${modifier}+b" = "exec firefox-esr";
            "${modifier}+r" = "exec dolphin";
            "${modifier}+space" = "exec --no-startup-id i3-dmenu-desktop";
            "${modifier}+Shift+p" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";

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
          };
        };
      };
    };
  };
}
