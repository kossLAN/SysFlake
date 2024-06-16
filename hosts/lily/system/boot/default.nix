{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.apple-silicon-support.nixosModules.default
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = lib.mkForce false;
      driSupport = true;
    };

    asahi = {
      enable = true;
      withRust = true;
      useExperimentalGPUDriver = true;
      setupAsahiSound = true;
      experimentalGPUInstallMode = "overlay";
      peripheralFirmwareDirectory = ./firmware;
    };
  };
}
