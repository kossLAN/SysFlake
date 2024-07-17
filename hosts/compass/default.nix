{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware
    ./boot
    ./programs
    ./services

    outputs.universalModules
    outputs.nixosModules
    inputs.jovian.nixosModules.jovian
  ];

  system.defaults.enable = true;

  environment = {
    sessionVariables = {
      SHELL = "/run/current-system/sw/bin/zsh";
    };

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
  };
}
