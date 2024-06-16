{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.utils;
in {
  # Common apps...
  options.programs.utils = {
    enable = mkEnableOption "Basic Utils";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        nmap
        ripgrep
        fastfetch
      ];
    };
  };
}
