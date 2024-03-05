{ lib
, pkgs
, platform
, inputs
, ...
}:
let
  allowedPlatforms = [ "macbook" ];
in
{
  home.activation = lib.mkIf (builtins.elem platform allowedPlatforms) {
    trampolineApps =
      let
        mac-app-util = inputs.mac-app-util.packages.aarch64-darwin.default;
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        fromDir="$HOME/Applications/Home Manager Apps"
        toDir="$HOME/Applications/Home Manager Trampolines"
        ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
      '';
  };
}
