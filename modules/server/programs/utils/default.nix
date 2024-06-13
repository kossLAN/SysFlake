{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.utils;
in {
  options.programs.utils = {
    enable = mkEnableOption "Utils and what not";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop
      fastfetch
      nmap
    ];
  };
}
