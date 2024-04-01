{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.darwin.programs.hm.utils;
in
{
  options.darwin.programs.hm.utils = {
    enable = lib.mkEnableOption "utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      home.packages = with pkgs; [
        iterm2
        spotify
        discord
        gimp
      ];
    };
  };
}
