{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.virt.vmware;
in {
  options.virt.vmware = {
    enable = mkEnableOption "vmware";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      vmware = {
        host = {
          enable = true;
          extraConfig = ''
            # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
            mks.gl.allowUnsupportedDrivers = "TRUE"
            mks.vk.allowUnsupportedDevices = "TRUE"
          '';
        };
        guest.enable = true;
      };
    };
  };
}
