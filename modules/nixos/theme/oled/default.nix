{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.oled;
in {
  options.theme.oled = {
    enable = mkEnableOption "oled";
    cursorSize = mkOption {
      type = lib.types.int;
      default = 18;
    };
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "breeze";
    };

    # QT Common Apps - Move Elsewhere Maybe idk
    environment.systemPackages = with pkgs; [
      qt6.qtwayland
      kdePackages.breeze
      kdePackages.breeze-icons
      qt6.qtsvg
      qt6.qt5compat

      kdePackages.qqc2-desktop-style

      libsForQt5.dolphin
      libsForQt5.gwenview
      libsForQt5.ark
    ];

    home-manager.users.${config.users.defaultUser} = {
      # GTK
      home.packages = with pkgs; [
        glib
        nerdfonts
        /*
        (nerdfonts.override {fonts = ["FiraCode" "FantasqueSansMono" "JetBrainsMono"];})
        */
      ];

      gtk = {
        enable = true;
        theme = {
          package = pkgs.kdePackages.breeze-gtk;
          name = "Breeze-Dark";
        };
        iconTheme = {
          package = pkgs.kdePackages.breeze-icons;
          name = "breeze-dark";
        };

        gtk3.extraConfig.gtk-xft-rgba = "rgb";
        gtk4.extraConfig.gtk-xft-rgba = "rgb";
      };

      xdg.configFile = {
        # "kdeglobals".source = ./kdeglobals;

        "qt5ct/qt5ct.conf".text = ''
          [Appearance]
          style=Breeze
          icon_theme=breeze-dark
          standard_dialogs=xdgdesktopportal

          color_scheme_path=${./colors-qt5.conf}
          custom_palette=true

          [Fonts]
          fixed="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"
          general="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"

          [Interface]
          buttonbox_layout=0
          cursor_flash_time=1000
          dialog_buttons_have_icons=2
          double_click_interval=400
          gui_effects=General, AnimateMenu, AnimateCombo
          keyboard_scheme=2
          menus_have_icons=true
          show_shortcuts_in_context_menus=true
          toolbutton_style=4
          underline_shortcut=1
          wheel_scroll_lines=2
        '';

        "qt6ct/qt6ct.conf".text = ''
          [Appearance]
          style=Breeze
          icon_theme=breeze-dark
          standard_dialogs=xdgdesktopportal

          color_scheme_path=${./colors-qt6.conf}
          custom_palette=true

          [Fonts]
          fixed="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"
          general="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"

          [Interface]
          buttonbox_layout=0
          cursor_flash_time=1000
          dialog_buttons_have_icons=2
          double_click_interval=400
          gui_effects=General, AnimateMenu, AnimateCombo
          keyboard_scheme=2
          menus_have_icons=true
          show_shortcuts_in_context_menus=true
          toolbutton_style=4
          underline_shortcut=1
          wheel_scroll_lines=2
        '';
      };

      # Cursor
      home.pointerCursor = let
        getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          inherit name;
          size = cfg.cursorSize;
          package = pkgs.runCommand "moveUp" {} ''
            mkdir -p $out/share/icons
            ln -s ${pkgs.fetchzip {
              inherit url hash;
            }} $out/share/icons/${name}
          '';
        };
      in
        getFrom
        "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOs-Monterey.tar.gz"
        "sha256-MHmaZs56Q1NbjkecvfcG1zAW85BCZDn5kXmxqVzPc7M="
        "macOs-Monterey";
    };
  };
}
