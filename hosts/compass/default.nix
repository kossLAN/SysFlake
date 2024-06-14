{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./system
    outputs.universalModules
    outputs.nixosModules
    inputs.jovian.nixosModules.jovian
  ];

  system.defaults.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/zsh";
    };

    systemPackages = [pkgs.maliit-keyboard];

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
  };
}
