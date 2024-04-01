{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.theme.oled;
in
{
  options.theme.oled = {
    enable = lib.mkEnableOption "oled";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      # GTK
      home.packages = with pkgs; [ glib ];
      xdg.systemDirs.data =
        let
          schema = pkgs.gsettings-desktop-schemas;
        in
        [ "${schema}/share/gsettings-schemas/${schema.name}" ];
      gtk = {
        enable = true;
        theme = {
          name = "Orchis-Dark";
          package = pkgs.orchis-theme.override {
            tweaks = [ "black" "solid" ];
          };
        };
        iconTheme = {
          package = pkgs.colloid-icon-theme;
          name = "Colloid";
        };
        font = {
          name = "FantasqueSansMono Nerd Font";
          size = 11;
        };
        gtk3.extraConfig = {
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
        };
        gtk2.extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      qt = {
        enable = true;
        platformTheme = "qtct";
        style = {
          name = "breeze";
        };
      };

      # xdg.configFile = {
      #   "qt5ct/qt5ct.conf".text = ''
      #     [Appearance]
      #     color_scheme_path=/home/koss/.nix-profile/share/qt6ct/colors/darker.conf
      #     custom_palette=true
      #     icon_theme=Colloid-light
      #     standard_dialogs=xdgdesktopportal
      #     style=Breeze
      #   '';
      #   "qt6ct/qt6ct.conf".text = ''
      #     [Appearance]
      #     color_scheme_path=/home/koss/.nix-profile/share/qt6ct/colors/darker.conf
      #     custom_palette=true
      #     standard_dialogs=xdgdesktopportal
      #     style=Breeze
      #   '';
      # };

      # Cursor
      home.pointerCursor =
        let
          getFrom = url: hash: name: {
            gtk.enable = true;
            x11.enable = true;
            inherit name;
            size = 18;
            package = pkgs.runCommand "moveUp" { } ''
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
