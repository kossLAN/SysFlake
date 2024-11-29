{
  lib,
  config,
  ...
}: let
  cfg = config.programs.noisetorch;

  inherit (lib.modules) mkIf;
in {
  config = mkIf cfg.enable {
    systemd.user.services.noisetorch = {
      after = ["pipewire-pulse.service"];
      wantedBy = ["pipewire-pulse.service"];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -i -o";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
