{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./system

    outputs.universalModules
    outputs.serverModules
    inputs.secrets.secretModules
  ];

  system.defaults.enable = true;
}
