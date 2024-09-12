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

  networking.hostname = "galahad";

  nixpkgs.hostPlatform = "x86_64-linux";

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
