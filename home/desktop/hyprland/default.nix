{ pkgs
, inputs
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
if (builtins.elem platform allowedPlatforms)
then {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./waybar
  ];

  home = {
    packages = with pkgs; [
      swaybg
      hyprpicker
      grimblast
      grim
      slurp
      swaynotificationcenter
      networkmanagerapplet
      libnotify
      playerctl
      inputs.anyrun.packages.${system}.anyrun
    ];

    file = {
      ".config/anyrun".source = ./anyrun;
      ".config/swaync".source = ./swaync;
    };
  };

  # Main color accents, here for convenience.
  #   text #ffffff
  #   accent_1 rgba(0, 0, 0, 0.05)
  #   main_bg #303446
  #   blue_1 #99c1f1
  #   blue_2 #62a0ea
  #   blue_3 #3584e4
  #   blue_4 #1c71d8
  #   blue_5 #1a5fb4

  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;

    #TODO: Split this up into multiple files for convenience
    #TODO: Also make it mmuch cleaner this is a mess from just messing around with it alot
    extraConfig = ''
        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = waybar &
        exec-once = env -u WAYLAND_DISPLAY insync start --no-daemon
        exec-once = swaync -s ~/.config/swaync/style.css -c ~/.config/swaync/config.js

        exec = swaybg -m fill -i ${./wallpapers/wallhaven-vqv3ml.jpg}
        exec = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        exec = nm-applet

        env = WLR_DRM_NO_ATOMIC,1
        env = GDK_BACKEND=wayland

        #Monitors
        monitor=WL-1,1200x800, 0x0, 1
        monitor=DP-1,2560x1440@240.0,0x0,1.0

        # general {
        #   gaps_in             = 3
        #   gaps_out            = 5
        #   border_size         = 2
        #   col.active_border   = rgba(99c1f1ff)
        #   col.inactive_border = rgba(62a0eaff)
        #   layout              = dwindle
        #   resize_on_border    = true
        #   allow_tearing       = true
        # }

        general {
          gaps_in             = 3
          gaps_out            = 5
          border_size         = 1
          col.active_border   = rgba(ffffffff)
          col.inactive_border = rgba(64727db3)
          layout              = dwindle
          resize_on_border    = true
          allow_tearing       = true
        }

        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        decoration {
        # rounding
        # rounding               = 10
        rounding               = 5

        blur {
          # blur
          enabled           = true
          size              = 8
          passes            = 2
          noise             = 0
          contrast          = 1
          new_optimizations = true
        }

        # shadow
        drop_shadow            = false
        shadow_range           = 4
        shadow_render_power    = 3
        col.shadow             = rgba(1a1a1aee)
      }

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      animations {
        enabled   = true
        bezier    = myBezier    , 0.71 , 0.18 , 1   , 0.09
        bezier    = workspaces  , 1    , 0.25 , 0   , 0.75
        bezier    = angle       , 1    , 1    , 1   , 1

        animation = windows     , 1    , 3    , default
        animation = windowsOut  , 1    , 3    , workspaces , popin
        animation = windowsIn   , 1    , 3    , workspaces , popin
        animation = border      , 1    , 5    , default
        animation = borderangle , 1    , 25   , angle      ,
        animation = fade        , 1    , 7    , default
        animation = workspaces  , 1    , 2    , workspaces , slide
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
        pseudotile     = false # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # you probably want this
        force_split    = 2
        smart_split    = false
        smart_resizing = true
      }

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod         , return    , exec           , foot
      bind = $mainMod         , T    , exec           , foot -T foot_float
      bind = $mainMod         , Q         , killactive     ,
      bind = $mainMod         , R         , exec           , nemo
      bind = $mainMod         , F         , fullscreen           ,
      bind = $mainMod         , B         , exec           , firefox
      bind = $mainMod         , V         , exec           , codium
      bind = $mainMod         , S         , togglefloating ,
      bind = $mainMod         , SPACE     , exec           , anyrun
      # bind = $mainMod         , P         , pseudo         , # dwindle
      bind = $mainMod         , J         , togglesplit    , # dwindle
      #bind = $mainMod         , L         , exit           ,
      #bind = $mainMod         , Print         , exec           , hyprpicker
      bind = $mainMod                 , P      , exec           , grimblast --notify copysave area ~/Pictures/Screenshots/$(date +'Screenshot_%s.png')
      bind =                  , Print     , exec           , grimblast --notify copysave area ~/Pictures/Screenshots/$(date +'Screenshot_%s.png')
      #bind = CONTROL SHIFT    , 9         , exec           , swaync-client -rs
      #bind = CONTROL SHIFT    , 0         , exec           , swaync-client --reload-config
      #bind = $mainMod         , N         , exec           , swaync-client -t -sw
      #bind = $mainMod         , R         , exec           , ~/.dots/waybar/launch.sh
      #bind = $mainMod         , R         , exec           , ~/.dots/ags/launch.sh

      # Move focus with mainMod + arrow keys
      bind = $mainMod , up    , movefocus, u
      bind = $mainMod , down  , movefocus, d
      bind = $mainMod , left    , movefocus, l
      bind = $mainMod , right  , movefocus, r

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod , 1     , workspace , 1
      bind = $mainMod , 2     , workspace , 2
      bind = $mainMod , 3     , workspace , 3
      bind = $mainMod , 4     , workspace , 4
      bind = $mainMod , 5     , workspace , 5
      bind = $mainMod , 6     , workspace , 6
      bind = $mainMod , 7     , workspace , 7
      bind = $mainMod , 8     , workspace , 8
      bind = $mainMod , 9     , workspace , 9
      bind = $mainMod , 0     , workspace , 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT , 1 , movetoworkspace , 1
      bind = $mainMod SHIFT , 2 , movetoworkspace , 2
      bind = $mainMod SHIFT , 3 , movetoworkspace , 3
      bind = $mainMod SHIFT , 4 , movetoworkspace , 4
      bind = $mainMod SHIFT , 5 , movetoworkspace , 5
      bind = $mainMod SHIFT , 6 , movetoworkspace , 6
      bind = $mainMod SHIFT , 7 , movetoworkspace , 7
      bind = $mainMod SHIFT , 8 , movetoworkspace , 8
      bind = $mainMod SHIFT , 9 , movetoworkspace , 9
      bind = $mainMod SHIFT , 0 , movetoworkspace , 10

      # Move active window in workspace
      bind = $mainMod ALT , left  , movewindow, l
      bind = $mainMod ALT , right , movewindow, r
      bind = $mainMod ALT , up    , movewindow, u
      bind = $mainMod ALT , down  , movewindow, d

      # Audiocontrol with mediakeys & show OSD values
      bind =, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0
      bind =, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0
      bind =, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # Resize windows with mainMod CTRL + arrowkeys
      bind = $mainMod CONTROL, right , resizeactive , 30  0
      bind = $mainMod CONTROL, left  , resizeactive , -30 0
      bind = $mainMod CONTROL, up    , resizeactive , 0   -30
      bind = $mainMod CONTROL, down  , resizeactive , 0   30

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod , mouse:272 , movewindow
      bindm = $mainMod , mouse:273 , resizewindow

      # Define window behaviour

      windowrulev2 = immediate , class:^(cs2)$
      windowrulev2 = immediate , class:^(osu!.exe)$
      windowrulev2 = immediate , class:^(osu!)$
      windowrulev2 = immediate , class:^(osu!lazer)$
      windowrulev2 = immediate , class:^(r5apex.exe)$
      windowrulev2 = immediate , class:^(r5apex)$
      windowrulev2 = immediate , xwayland:1
      windowrule=float,title:^(foot_float)$


      # Default Startup

      windowrule = workspace 2, spotify
      # windowrule = workspace 2, vesktop
      windowrule = workspace 4, codium
      windowrule = workspace 5, keepassxc

      # exec-once = [workspace 2 silent] vesktop
      exec-once = [workspace 2 silent] spotify
      exec-once = [workspace 3 silent] firefox
      #exec-once = [workspace 4 silent] codium
      exec-once = [workspace 5 silent] keepassxc


      # Some default env vars.
      #env = XCURSOR_SIZE , 32

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout      = us
          kb_variant     =
          kb_model       =
          kb_options     =
          kb_rules       =
          follow_mouse   = 1
          sensitivity    = 0 # -1.0 - 1.0, 0 means no modification.
          accel_profile  = flat
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      # master {
      #     new_is_master = true
      # }

      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      gestures {
          workspace_swipe = true
      }

      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      # device:logitech-mx-master-2s-1 {
      #     sensitivity = 50
      # }

      misc {
          vfr                      = true
          vrr                      = 0
          animate_manual_resizes   = false
          focus_on_activate        = false
          render_ahead_of_time     = false
          disable_hyprland_logo    = false
          no_direct_scanout        = false
      }

      debug {
          overlay = false
      }
    '';
  };
}
else {
  # imports = [];
}
