{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.devTools;
in {
  options.programs.devTools = {
    # I could probably classify this better but this is just stuff I need thus I have a module so I can
    # use on mutiple machines
    enable = lib.mkEnableOption "devTools";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      java = {
        enable = true;
        package = pkgs.openjdk;
      };

      # Run dynamically linked libs (try to avoid as much as possible)
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
        ];
      };
    };
  };
}
