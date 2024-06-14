{
  inputs,
  outputs,
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

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
  };
}
