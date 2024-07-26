{inputs, ...}: {
  imports = [
    ./services
    ./programs
    ./disks

    inputs.secrets.secretModules
  ];

  networking.hostName = "cerebrite";
  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
