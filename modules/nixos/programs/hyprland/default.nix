{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.hyprland;
in {
  config = mkIf cfg.enable {
    # XDG Portal Nonsense
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.libsForQt5.xdg-desktop-portal-kde];

      config.common = {
        default = [
          "hyprland"
          "kde"
        ];
      };
    };

    # System Apps that I will use on this shit
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
      };

      systemPackages = with pkgs; [
        libsForQt5.dolphin
        libsForQt5.gwenview
        libsForQt5.ark
        libsForQt5.kdenlive
      ];
    };

    # Breeze theme
    theme = {
      breeze.enable = true;

      cursor = {
        enable = true;
        cursorSize = 24;
      };
    };

    programs = {
      nm-applet.enable = true;
      # quickshell.enable = true;

      waybar = {
        enable = true;
        defaults.enable = true;
      };

      anyrun = {
        enable = true;
        defaults.enable = true;
      };

      # hyprland = {
      #   package = inputs.hyprland.packages.${pkgs.system}.default;
      #   portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      # };
    };

    home-manager.users.${config.users.defaultUser} = {
      services = {
        hypridle = {
          enable = true;
          settings = {
            general = {
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
              lock_cmd = "hyprctl dispatch dpms off";
            };

            listener = [
              {
                timeout = 300;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        # package = inputs.hyprland.packages.${pkgs.system}.default;

        settings = let
          mainMod = "SUPER";
        in {
          general = {
            gaps_in = "3";
            gaps_out = "5";
            border_size = "2";
            layout = "dwindle";
            resize_on_border = true;

            allow_tearing = true;

            "col.active_border" = "rgba(ffffffff)";
            "col.inactive_border" = "rgba(64727db3)";
          };

          decoration = {
            rounding = "5";
            # drop_shadow = true;
            # shadow_range = "4";
            # shadow_render_power = "3";
            # "col.shadow" = "rgba(1a1a1aee)";

            blur = {
              enabled = false;
              size = "8";
              passes = "5";
              noise = "0";
              contrast = "1";
              new_optimizations = true;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "linear, 0.5, 0.5, 0.5, 0.5"
              "antiEase, 0.6, 0.4, 0.6, 0.4"
              "ease, 0.4, 0.6, 0.4, 0.6"
              "smooth, 0.5, 0.9, 0.6, 0.95"
              "htooms, 0.95, 0.6, 0.9, 0.5"
              "powered, 0.5, 0.2, 0.6, 0.5"
            ];

            animation = [
              "windows, 1, 2.5, smooth"
              "windowsOut, 1, 1, htooms, popin 80%"
              "fade, 1, 5, smooth"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
            smart_split = false;
            smart_resizing = true;
          };

          input = {
            kb_layout = "us";
            follow_mouse = "1";
            sensitivity = "0";
            accel_profile = "flat";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";
          };

          misc = {
            vfr = true;
            vrr = 0;
            animate_manual_resizes = false;
            focus_on_activate = false;
            render_ahead_of_time = false;
            disable_hyprland_logo = false;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          render = {
            direct_scanout = false;
            explicit_sync = 1;
            explicit_sync_kms = 2;
          };

          xwayland = {
            enabled = true;
            force_zero_scaling = true;
          };

          monitor = ["DP-2,preferred,auto,1.25"];

          exec-once = [
            # DBUS Shit.
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

            # Wallpaper manager
            "${lib.getExe pkgs.swaybg} -m fill -i ${./background.png}"
          ];

          exec = [
            # Polkit for authentication prompts
            "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
          ];

          env = [
            "GDK_BACKEND,wayland"
            "QT_QPA_PLATFORM,wayland"
            "WLR_DRM_NO_ATOMIC,1"
          ];

          windowrulev2 = [
            # Tearing
            "immediate  , xwayland:1"

            # Custom rules
            "float                  , class:org.kde.polkit-kde-authentication-agent-1"
            "suppressevent maximize , class:.*"
          ];

          # layerrule = [
          #   "ignorezero , quickshell"
          #   "blur       , quickshell"
          #   "blurpopups , quickshell"
          # ];

          bind = [
            # General Keybinds
            "${mainMod}, F, fullscreen, "
            "${mainMod}, Q, killactive, "
            "${mainMod}, S, togglefloating, "
            # "${mainMod}, M, exit, "
            "${mainMod}, J, togglesplit, " # Dwindle

            # Navigation
            "${mainMod}, up   , movefocus, u"
            "${mainMod}, down , movefocus, d"
            "${mainMod}, left , movefocus, l"
            "${mainMod}, right, movefocus, r"

            "${mainMod} ALT , left  , movewindow, l"
            "${mainMod} ALT , right , movewindow, r"
            "${mainMod} ALT , up    , movewindow, u"
            "${mainMod} ALT , down  , movewindow, d"

            # Workspaces
            "${mainMod} , 1   , workspace , 1"
            "${mainMod} , 2   , workspace , 2"
            "${mainMod} , 3   , workspace , 3"
            "${mainMod} , 4   , workspace , 4"
            "${mainMod} , 5   , workspace , 5"
            "${mainMod} , 6   , workspace , 6"
            "${mainMod} , 7   , workspace , 7"
            "${mainMod} , 8   , workspace , 8"
            "${mainMod} , 9   , workspace , 9"
            "${mainMod} , 0   , workspace , 10"

            # Move window to specific workspace
            "${mainMod} SHIFT , 1 , movetoworkspace , 1"
            "${mainMod} SHIFT , 2 , movetoworkspace , 2"
            "${mainMod} SHIFT , 3 , movetoworkspace , 3"
            "${mainMod} SHIFT , 4 , movetoworkspace , 4"
            "${mainMod} SHIFT , 5 , movetoworkspace , 5"
            "${mainMod} SHIFT , 6 , movetoworkspace , 6"
            "${mainMod} SHIFT , 7 , movetoworkspace , 7"
            "${mainMod} SHIFT , 8 , movetoworkspace , 8"
            "${mainMod} SHIFT , 9 , movetoworkspace , 9"
            "${mainMod} SHIFT , 0 , movetoworkspace , 10"

            # Window Resize
            "${mainMod} CONTROL, right , resizeactive , 30  0"
            "${mainMod} CONTROL, left  , resizeactive , -30 0"
            "${mainMod} CONTROL, up    , resizeactive , 0   -30"
            "${mainMod} CONTROL, down  , resizeactive , 0   30"

            # Audio Control
            ", XF86AudioRaiseVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"
            ", XF86AudioLowerVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0"
            ", XF86AudioMute        , exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

            # Program Launch Keybinds
            "${mainMod}, return , exec, foot"
            "${mainMod}, R      , exec, dolphin"
            "${mainMod}, B      , exec, zen-bin"
            "${mainMod}, SPACE  , exec, anyrun"
            "${mainMod}, P      , exec, ${lib.getExe pkgs.grimblast} --notify copysave  area ~/Pictures/Screenshots/$(data + 'Screenshot_%s.png')"
          ];

          bindm = [
            "${mainMod}, mouse:272 , movewindow"
            "${mainMod}, mouse:273 , resizewindow"
          ];
        };
      };
    };
  };
}
