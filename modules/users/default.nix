{
  lib,
  config,
  inputs,
  self,
  ...
}: let
  cfg = config.users.defaultUser;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.users.defaultUser = lib.mkOption {
    type = lib.types.str;
    default = "koss";
  };

  config = {
    users.users.${config.users.defaultUser} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      initialPassword = "root";
    };

    home-manager = {
      extraSpecialArgs = {
        inherit self inputs;
      };

      useGlobalPkgs = true;
      users.${config.users.defaultUser} = {
        programs.home-manager.enable = true;
        home = {
          stateVersion = "23.11";
        };
        xdg.enable = true;
      };
    };
  };
}
