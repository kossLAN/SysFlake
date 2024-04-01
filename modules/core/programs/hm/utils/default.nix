{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.programs.hm.utils;
in
{
  # Common apps...
  options.programs.hm.utils = {
    enable = lib.mkEnableOption "utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      home.packages = with pkgs; [
        # Move these to hyprland config
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
    };
  };
}
