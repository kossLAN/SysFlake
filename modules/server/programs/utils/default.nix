{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.programs.utils;
in {
  options.programs.utils = {
    enable = lib.mkEnableOption "Utils and what not";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop
      fastfetch
      nmap
    ];
  };
}
