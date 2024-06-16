{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.programs.hyprland;
in {
  imports = [./anyrun];

  options.programs.hyprland = {
    defaults.enable = mkEnableOption ''
      My opioninated hyprland configuration, check module for everything this does.
      It's alot...
    '';

    defaults.additionalSettings = mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprland configuration value";
          };
      in
        valueType;
      default = {};
      description = ''
        Hyprland configuration written in nix that is added to the home-manager settings
        option for hyprland.
      '';
      example = lib.literalExpression ''
        {
          decoration = {
            shadow_offset = "0 5";
            "col.shadow" = "rgba(00000099)";
          };
        }
      '';
    };
  };

  config = mkIf cfg.defaults.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
      config.common.default = [
        "hyprland"
        "kde"
      ];
    };

    home-manager.users.${config.users.defaultUser} = {
      home = {
        packages = with pkgs; [
          swaybg
          hyprpicker
          grimblast
          grim
          slurp
          networkmanagerapplet
          libnotify

          inputs.quickshell.packages.${pkgs.system}.default
        ];

        file = {
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        # systemd.enable = true;

        settings = let
          mainMod = "SUPER";
        in
          {
            general = {
              gaps_in = "3";
              gaps_out = "5";
              border_size = "1";
              layout = "dwindle";
              resize_on_border = true;

              # allow_tearing = true;

              "col.active_border" = "rgba(ffffffff)";
              "col.inactive_border" = "rgba(64727db3)";
            };

            decoration = {
              rounding = "5";
              drop_shadow = true;
              shadow_range = "4";
              shadow_render_power = "3";
              "col.shadow" = "rgba(1a1a1aee)";

              blur = {
                enabled = true;
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
              vrr = "1";
              animate_manual_resizes = false;
              focus_on_activate = false;
              render_ahead_of_time = false;
              disable_hyprland_logo = false;
              no_direct_scanout = false;
            };

            exec-once = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "quickshell &"
              "swaybg -m fill -i ${./wallpapers/wallhaven-vqv3ml.jpg}"
            ];

            exec = [
              "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
            ];

            env = [
              "GDK_BACKEND=wayland"
              "WLR_DRM_NO_ATOMIC=1"
            ];

            windowrulev2 = [
              # Tearing
              "immediate  , class:^(cs2)$"
              "immediate  , xwayland:1"

              # Custom
              "float                  , title:^(foot_float)$"
              "suppressevent maximize , class:.*"
            ];

            layerrule = [
              "ignorezero , quickshell"
              "blur       , quickshell"
              "blurpopups , quickshell"
            ];

            bind = [
              # General Keybinds
              "${mainMod}, F, fullscreen, "
              "${mainMod}, Q, killactive, "
              "${mainMod}, S, togglefloating, "
              "${mainMod}, M, exit, "
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
              "${mainMod}, T      , exec, foot - T foot_float"
              "${mainMod}, R      , exec, dolphin"
              "${mainMod}, B      , exec, firefox-esr"
              "${mainMod}, SPACE  , exec, anyrun"
              "${mainMod}, P      , exec, grimblast --notify copysave  area ~/Pictures/Screenshots/$(data + 'Screenshot_%s.png')"
            ];

            bindm = [
              "${mainMod}, mouse:272 , movewindow"
              "${mainMod}, mouse:273 , resizewindow"
            ];
          }
          // config.programs.hyprland.defaults.additionalSettings;
        # This is a fucking cool operator that I wasn't aware of.
      };
    };
  };
}
