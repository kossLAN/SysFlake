{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.game;
in {
  imports = [./mangohud];

  options.programs.hm.game = {
    enable = lib.mkEnableOption "game";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        radeontop
        btop
        lutris
        prismlauncher
        gamemode
        protonup-qt
        #heroic
        #rpcs3
        protontricks
        wine
        winetricks
        xivlauncher
        r2modman
        #inputs.nix-gaming.packages.${pkgs.system}.osu-stable
        #inputs.nix-gaming.packages.${pkgs.system}.osu-mime
        #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
        #osu-lazer
      ];
    };
  };
}
