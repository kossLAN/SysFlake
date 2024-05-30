{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.dev.java;
in {
  options.programs.dev.java = {
    enable = lib.mkEnableOption "Java support";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      java = {
        enable = true;
        package = pkgs.openjdk;
      };
    };
  };
}
