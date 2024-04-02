{
  lib,
  config,
  ...
}: let
  cfg = config.virt.docker;
in {
  options.virt.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
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
