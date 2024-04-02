{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hm.foot;
in {
  options.programs.hm.foot = {
    enable = lib.mkEnableOption "foot";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            shell = "zsh";
            term = "xterm-256color";
            font = "JetBrainsMono Nerd Font:size=12";
          };

          cursor = {
            color = "181818 cdcdcd";
          };

          colors = {
            foreground = "cdcdcd";
            background = "000000";
            regular0 = "000000";
            regular1 = "ff8599";
            regular2 = "00c545";
            regular3 = "de9d00";
            regular4 = "00b4ff";
            regular5 = "fd71f8";
            regular6 = "00bfae";
            regular7 = "cdcdcd";
            bright0 = "262626";
            bright1 = "ff9eb2";
            bright2 = "19de5e";
            bright3 = "f7b619";
            bright4 = "19cdff";
            bright5 = "ff8aff";
            bright6 = "19d8c7";
            bright7 = "dadada";
          };

          key-bindings = {
            clipboard-copy = "Control+c";
            clipboard-paste = "Control+v";
          };
        };
      };
    };
  };
}
