{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.hardware.laptop;
in {
  options.hardware.laptop = {
    enable = mkEnableOption "Laptop configuration";
    amd.enable = mkEnableOption "AMD specific laptop configuration";
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "schedutil";
    };

    services.tlp = {
      enable = true;
      settings = {
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_ON_AC = 0;

        WIFI_PWR_ON_AC = "on";
        WIFI_PWR_ON_BAT = "on";

        WOL_DISABLE = "Y";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        USB_AUTOSUSPEND = 0;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };

    # Kernel Laptop Parameters
    boot.kernelParams =
      [
        "quiet"
        "splash"
      ]
      ++ mkIf cfg.amd.enable ["amd_pstate=passive"];
  };
}
