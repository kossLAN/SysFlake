{
  lib,
  config,
  inputs,
  self,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.users.defaultUser = mkOption {
    type = lib.types.str;
    default = "koss";
  };

  config = {
    programs.zsh = {
      enable = true;
      shellInit = "autoload -Uz add-zsh-hook";
    };

    users = {
      defaultUserShell = pkgs.zsh; # Default shell.
      users.${config.users.defaultUser} = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["wheel" "docker"];
        initialPassword = "root";
      };
    };

    home-manager = {
      extraSpecialArgs = {
        inherit self inputs;
      };

      useGlobalPkgs = true;
      users.${config.users.defaultUser} = {
        programs.home-manager.enable = true;
        home = {
          stateVersion = config.system.stateVersion;
        };
        xdg.enable = true;
      };
    };
  };
}
