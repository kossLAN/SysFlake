{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.kitty;
in {
  options.programs.kitty = {
    enable = mkEnableOption "Home-manager module wrapper for kitty";
    defaults.enable = mkEnableOption "Opinionated defaults for kitty";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.kitty = {
        enable = cfg.enable;
        settings = {
          term = "xterm-256color";
        };
        # Nothing here really yet
      };
    };
  };
}
