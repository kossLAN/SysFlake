{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.display.amd;
in {
  # Just common things I enable for AMD GPU's ROCM + Drivers w/e
  options.display.amd = {
    enable = mkEnableOption "amd common";
  };

  config = mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
          amdvlk
        ];

        extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
      };
    };

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

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
