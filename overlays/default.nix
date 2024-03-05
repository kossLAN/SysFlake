# This file defines overlays
{ inputs, ... }: 
let
  imagedir = ./assets;
in
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    sddm-chili-theme = prev.sddm-chili-theme.overrideAttrs (oldAttrs: rec {
      postInstall = ''
        mkdir -p $out/share/sddm/themes/chili
        mv Main.qml $out/share/sddm/themes/chili/
        mv theme.conf $out/share/sddm/themes/chili/
        mv components $out/share/sddm/themes/chili/

        mkdir $out/share/sddm/themes/chili/assets
        mv assets/*.svgz $out/share/sddm/themes/chili/assets
        cp ${imagedir}/background.jpg $out/share/sddm/themes/chili/assets
      '';
    }); 
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # steam = prev.steam.override ({ extraPkgs ? pkgs': [ ], ... }: {
    #   extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
    #     v8
    #   ]);
    # });
  };
}
