{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./services
    ./programs
    ./disks

    outputs.universalModules
    outputs.serverModules
    inputs.secrets.secretModules
  ];

  system.defaults.enable = true;
}
