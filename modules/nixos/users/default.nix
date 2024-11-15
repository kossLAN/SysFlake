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
  custom-zsh = inputs.custom-zsh.packages.${pkgs.stdenv.system}.default;
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
    programs.zsh = {
      enable = true;
      shellInit = "autoload -Uz add-zsh-hook";
    };

    users = {
      defaultUserShell = pkgs.zsh;
      users.${config.users.defaultUser} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        initialPassword = "root";
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "old";

      extraSpecialArgs = {
        inherit self inputs;
      };

      users.${config.users.defaultUser} = {
        programs.home-manager.enable = true;
        xdg.enable = true;

        home = {
          stateVersion = config.system.stateVersion;
          packages = cfg.packages;
        };
      };
    };
  };
}
