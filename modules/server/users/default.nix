{
  lib,
  config,
  inputs,
  self,
  pkgs,
  stateVersion,
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
    users = {
      defaultUserShell = pkgs.zsh; # Default shell.
      users.${config.users.defaultUser} = {
        isNormalUser = true;
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
          stateVersion = stateVersion;
        };
        xdg.enable = true;
      };
    };
  };
}
