{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.cursor.notwaita;
in {
  options.theme.cursor.notwaita = {
    enable = mkEnableOption "Notwaita Cursor theme";
  };

  config = mkIf cfg.enable {
    theme.cursor = let
      url = "https://github.com/ful1e5/notwaita-cursor/releases/download/v1.0.0-alpha1/Notwaita-Black.tar.xz";
      hash = "sha256-ZLr0C5exHVz6jeLg0HGV+aZQbabBqsCuXPGodk2P0S8=";
      name = "Notwaita-Black";
    in {
      enable = true;
      name = name;
      package = pkgs.runCommand "moveUp" {} ''
        mkdir -p $out/share/icons/default
        ln -s ${pkgs.fetchzip {
          inherit url hash;
        }} $out/share/icons/${name}
        cp ${pkgs.writeTextFile {
          name = "index.theme";
          destination = "/share/icons/default/index.theme";
          text = ''
            [Icon Theme]
            Name=Default
            Comment=Default Cursor Theme
            Inherits=${name}
          '';
        }}/share/icons/default/index.theme \
          $out/share/icons/default/index.theme
      '';
    };
  };
}
