{
  lib,
  config,
  inputs,
  self,
  pkgs,
  ...
}: let
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

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submoduleWith {
        modules = [
          ({lib, ...}: {
            options.file = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options = {
                  text = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = "Content of the file to be created.";
                  };
                  mode = lib.mkOption {
                    type = lib.types.str;
                    default = "0644";
                    example = "0600";
                    description = "Permissions mode for the file in octal format.";
                  };
                  group = lib.mkOption {
                    type = lib.types.str;
                    default = "users";
                    description = "Group owner of the file.";
                  };
                };
              });
              default = {};
              description = ''
                Files to be created in the user's home directory.
                The attribute name is the relative path from the home directory.
              '';
            };
          })
        ];
        shorthandOnlyDefinesConfig = true;
      });
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

    # Replacement for home-manager's home.file, in esssence we just make a service
    # for each user that defines a file, then we link the file from the store on
    # start. On stop we remove the link.
    systemd.services = lib.filterAttrs (_: v: v != {}) (lib.mapAttrs' (
        username: userConfig:
          lib.nameValuePair "manage-user-files-${username}" (
            if (userConfig.file or {}) != {}
            then {
              description = "Manage dotfiles linking for ${username}";
              wantedBy = ["multi-user.target"];
              restartIfChanged = true;

              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = username;

                ExecStart = pkgs.writeShellScript "manage-user-files-${username}" ''
                  set -euo pipefail
                  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (filename: fileConfig: ''
                      mkdir -p "/home/${username}"
                      rm -f "/home/${username}/${filename}"
                      ln -sf "${pkgs.writeText filename fileConfig.text}" "/home/${username}/${filename}"
                    '')
                    userConfig.file)}
                '';

                ExecStop = pkgs.writeShellScript "cleanup-user-files-${username}" ''
                  set -euo pipefail
                  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (filename: _: ''
                      rm -f "/home/${username}/${filename}"
                    '')
                    userConfig.file)}
                '';
              };
            }
            else {}
          )
      )
      config.users.users);

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
