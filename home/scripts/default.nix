{ pkgs
, inputs
, self
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
  serialPort = "/dev/ttyACM0";
  kvmScript1 =
    let
      inherit (pkgs) ddcutil;
      _ = lib.getExe;
    in
    pkgs.writeShellScriptBin "kvm1" ''
      ${./bin/program} 1 ${serialPort}
      ${_ ddcutil} setvcp x60 0x0f
    '';
  kvmScript2 =
    let
      inherit (pkgs) ddcutil;
      _ = lib.getExe;
    in
    pkgs.writeShellScriptBin "kvm2" ''
      ${./bin/program} 2 ${serialPort}
      ${_ ddcutil} setvcp x60 0x11
    '';
  # podmanKill = let
  #     inherit (pkgs) podman;s
  #     _ = lib.getExe;
  # in
  #     pkgs.writeShellScriptBin "kill-podman-images" ''
  #         ${_ podman} rmi $(podman images -qa) -f
  #     '';
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs; [
    kvmScript1
    kvmScript2
  ];
}
