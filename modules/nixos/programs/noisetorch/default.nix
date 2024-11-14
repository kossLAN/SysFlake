{
  lib,
  config,
  ...
}: let
  cfg = config.programs.noisetorch;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
in {
  options.programs.noisetorch = {
    device = mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      systemd.user.services.noisetorch = {
        Unit = {
          After = ["pipewire-pulse.service"];
        };

        Service = {
          ExecStart = "${lib.getExe cfg.package} -i ${cfg.device} -o";
          Restart = "on-failure";
        };

        Install = {WantedBy = ["pipewire-pulse.service"];};
      };
    };
  };
}
