#https://github.com/catppuccin/gtk
{ pkgs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs; [ glib ]; # gsettings
  xdg.systemDirs.data =
    let
      schema = pkgs.gsettings-desktop-schemas;
    in
    [ "${schema}/share/gsettings-schemas/${schema.name}" ];
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Frappe-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" "normal" ];
        variant = "frappe";
      };
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
      name = "Papirus-Dark";
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
      name = "adwaita"; 
    };
  };



  xdg.configFile = {
    #"Kvantum/kvantum.kvconfig".text = ''
    #  [General]
    #  theme=Catppuccin
    #'';
    #"Kvantum/Catppuccin".source = ./Catppuccin;

    # "qt5ct/qt5ct.conf".text = ''
    #     [Appearance] 
    #     # exact same colors.
    #     color_scheme_path=${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/Catppuccin-Frappe.conf
    #     custom_palette=true
    # '';
    # "qt6ct/qt6ct.conf".text = '' 
    #     [Appearance]
    #     color_scheme_path=${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/Catppuccin-Frappe.conf
    #     custom_palette=true
    #     standard_dialogs=xdgdesktopportal
    # ''; 
  };
}
