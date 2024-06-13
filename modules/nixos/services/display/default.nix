{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.amdGpu;
in {
  #TODO; may abstract this further into a module because
  # this should be pretty much the same on all my systems..
  options.services.amdGpu = {
    enable = mkEnableOption "amdGpu";
  };

  config = mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    services = {
      libinput.enable = true;

      xserver = {
        enable = true;

        videoDrivers = ["amdgpu"];
        xkb.layout = "us";
      };
    };
  };
}
