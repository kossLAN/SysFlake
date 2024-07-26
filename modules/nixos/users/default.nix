{
  lib,
  config,
  inputs,
  self,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;

  cfg = config.users;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.users = {
    defaultUser = mkOption {
      type = lib.types.str;
      default = "koss";
    };

    packages = mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = ''
        A easy way to pass through packages from regular configuration to home manager
      '';
    };
  };

  config = {
    users = {
      defaultUserShell = mkIf config.programs.zsh.enable pkgs.zsh;
      users.${config.users.defaultUser} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        initialPassword = "root";
      };
    };

    environment.sessionVariables = {
      SHELL = mkIf config.programs.zsh.enable "/run/current-system/sw/bin/zsh";
    };

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "old";

      extraSpecialArgs = {
        inherit self inputs;
      };

      users.${config.users.defaultUser} = {
        programs.home-manager.enable = true;
        home = {
          stateVersion = config.system.stateVersion;
          packages = cfg.packages;
        };
        xdg.enable = true;
      };
    };
  };
}
