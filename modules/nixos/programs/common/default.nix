{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.common;
in {
  # Common apps...
  options.programs.common = {
    enable = mkEnableOption "Basic Utils";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        btop
        nmap
        ripgrep
        fastfetch
      ];
    };
  };
}
