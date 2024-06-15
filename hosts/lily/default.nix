{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system
    inputs.apple-silicon-support.nixosModules
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = lib.mkForce false;
      driSupport = true;
    };

    asahi = {
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "overlay";
      peripheralFirmwareDirectory = ./firmware;
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.hyprland.enable = true;

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    kitty
    keepassxc
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
