{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.neovim;
in {
  options.programs.neovim = {
    defaults.enable = mkEnableOption "Enable neovim opioninated defaults";
  };

  config = mkIf cfg.defaults.enable { 
  };
}
