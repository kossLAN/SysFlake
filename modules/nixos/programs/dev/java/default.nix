{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.dev.java;
in {
  options.programs.dev.java = {
    enable = mkEnableOption "Java support";
  };

  config = mkIf cfg.enable {
    programs = {
      java = {
        enable = true;
        package = pkgs.openjdk;
      };
    };
  };
}
