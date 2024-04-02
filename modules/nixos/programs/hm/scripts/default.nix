{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.scripts;
in {
  # Not in use, but left here as an example
  options.programs.hm.scripts = {
    enable = lib.mkEnableOption "scripts";
  };
  config = let
    allowedPlatforms = ["desktop"];
    serialPort = "/dev/ttyACM0";
    kvmScript1 = let
      inherit (pkgs) ddcutil;
      _ = lib.getExe;
    in
      pkgs.writeShellScriptBin "kvm1" ''
        ${./bin/program} 1 ${serialPort}
        ${_ ddcutil} setvcp x60 0x0f
      '';
  in
    lib.mkIf cfg.enable {
      home-manager.users.${config.users.defaultUser} = {
        home.packages = with pkgs; [
        ];
      };
    };
}
