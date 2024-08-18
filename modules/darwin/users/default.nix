{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.users.defaultUser;
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  options.users.defaultUser = lib.mkOption {
    type = lib.types.str;
    default = "koss";
  };

  config = {
    users.users.${cfg} = {
      home = "/Users/${cfg}";
      name = "${cfg}";
    };

    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
      };

      useGlobalPkgs = true;
      users.${cfg} = {
        programs.home-manager.enable = true;
        home = {
          stateVersion = "23.11";
        };
      };
    };
  };
}
