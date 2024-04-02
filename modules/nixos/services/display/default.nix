{
  lib,
  config,
  ...
}: let
  cfg = config.services.amdGpu;
in {
  #TODO; may abstract this further into a module because
  # this should be pretty much the same on all my systems..
  options.services.amdGpu = {
    enable = lib.mkEnableOption "amdGpu";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    services = {
      xserver = {
        enable = true;
        libinput.enable = true;

        videoDrivers = ["amdgpu"];
        layout = "us";
      };
    };
  };
}
