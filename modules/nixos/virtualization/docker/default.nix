{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.virt.docker;
in {
  options.virt.docker = {
    enable = mkEnableOption "docker";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = true;
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    users.users.koss.extraGroups = [
      "docker"
    ];
  };
}
