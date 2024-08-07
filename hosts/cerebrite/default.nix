{inputs, ...}: {
  imports = [
    ./services
    ./programs
    ./networking
    ./disks
    ./secrets

    inputs.secrets.secretModules
  ];

  networking.hostName = "cerebrite";

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
