{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.programs.custom-neovim;
in {
  # Common apps...
  options.programs.custom-neovim = {
    enable = mkEnableOption "custom-neovim";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.nvim-pkg;
    };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
      ];

      variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
    };
  };
}
