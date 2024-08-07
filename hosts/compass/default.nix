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
    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
  };
}
