{ lib
, config
, inputs
, ...
}:
let
  cfg = config.users.defaultUser;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.users.defaultUser = lib.mkOption {
    type = lib.types.str;
    default = "koss";
  };

  config = {
    users.users.${config.defaultUser} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "root";
    };

    home-manager = {
      extraSpecialArgs = {
        inherit lib config;
      };

      useGlobalPkgs = true;

      users.${config.defaultUser} = {
        programs.home-manager.enable = true;
        home = {
          stateVersion = "23.11";
        };
        xdg.enable = true;
      };
    };
  };
}
