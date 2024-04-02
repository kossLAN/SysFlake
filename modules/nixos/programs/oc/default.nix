{
  lib,
  config,
  ...
}: let
  cfg = config.programs.oc;
in {
  # This is needed to fix GPU clocks on linux for amdgpus...
  options.programs.oc = {
    enable = lib.mkEnableOption "oc";
  };

  config = lib.mkIf cfg.enable {
    programs.corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
  };
}
