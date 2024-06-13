{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) getExe;

  cfg = config.programs.hm.scripts;
in {
  # Not in use, but left here as an example
  options.programs.hm.scripts = {
    enable = mkEnableOption "scripts";
  };

  config = let
    serialPort = "/dev/ttyACM0";
    kvmScript1 = let
      inherit (pkgs) ddcutil;
      _ = getExe;
    in
      pkgs.writeShellScriptBin "kvm1" ''
        ${./bin/program} 1 ${serialPort}
        ${_ ddcutil} setvcp x60 0x0f
      '';
  in
    mkIf cfg.enable {
      home-manager.users.${config.users.defaultUser} = {
        home.packages = with pkgs; [
        ];
      };
    };
}
