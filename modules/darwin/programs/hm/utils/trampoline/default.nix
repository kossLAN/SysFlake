{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.programs.hm.utils.trampoline;
  hmLib = inputs.home-manager.lib;
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  # Adds apps to applications folder on mac
  options.programs.hm.utils.trampoline = {
    enable = lib.mkEnableOption "trampoline";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.activation = {
        trampolineApps = let
          mac-app-util = inputs.mac-app-util.packages.aarch64-darwin.default;
          fromDir = "/Users/${config.users.defaultUser}/Applications/Home Manager Apps/";
          toDir = "/Users/${config.users.defaultUser}/Applications/Home Manager Trampolines/";
        in
          hmLib.hm.dag.entryAfter ["writeBoundary"] ''
            echo 'mac-app-util sync-trampolines ${fromDir} ${toDir}' > ~/macAppLog.txt
            ${mac-app-util}/bin/mac-app-util sync-trampolines '${fromDir}' '${toDir}'
          '';
      };
    };
  };
}
