{
  pkgs,
  inputs,
  lib,
  platform,
  ...
}: let
  allowedPlatforms = ["desktop"];
in
  lib.mkIf (builtins.elem platform allowedPlatforms) {
    home.packages = with pkgs; [
      libsForQt5.dolphin
      libsForQt5.gwenview
      libsForQt5.ark

      deluge
      pavucontrol
      mpv
      firefox
      via
      virt-manager
      keepassxc
      BeatSaberModManager
      bambu-studio
      hplip
      libreoffice-qt
      plexamp
      protonvpn-cli_2
      nh
      (pkgs.vesktop.overrideAttrs (old: {
        postFixup = ''
          wrapProgram $out/bin/vesktop \
            --add-flags "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,UseMultiPlaneFormatForHardwareVideo"
        '';
      }))
    ];
  }
