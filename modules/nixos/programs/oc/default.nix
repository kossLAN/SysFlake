{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.oc;
in {
  # This is needed to fix GPU clocks on linux for amdgpus...
  options.programs.oc = {
    enable = mkEnableOption "oc";
  };

  config = mkIf cfg.enable {
    programs.corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
  };
}
