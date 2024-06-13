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
  imports = [./trampoline];

  options.programs.utils = {
    enable = mkEnableOption "utils";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        nerdfonts
        iterm2
        discord
        gimp
        prismlauncher
      ];
    };
  };
}
