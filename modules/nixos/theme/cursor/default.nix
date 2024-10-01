{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.cursor;
in {
  options.theme.cursor = {
    enable = mkEnableOption "Cursor theme";
    cursorSize = mkOption {
      type = lib.types.int;
      default = 18;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
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
