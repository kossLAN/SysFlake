{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.utils;
in {
  # Common apps...
  options.programs.hm.utils = {
    enable = lib.mkEnableOption "utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        # Move these to hyprland config
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
        nh
        vesktop
        # (pkgs.vesktop.overrideAttrs (old: {
        #   src = fetchFromGitHub {
        #     owner = "Vencord";
        #     repo = "Vesktop";
        #     rev = "05df122cf1c83e9f77293a9dc28bbc13be537134";
        #     hash = "sha256-+6CyMxYEK/nQLoxh7QWcknjn04e80bVlkLsf6Vg7SeI=";
        #   };
        #   # postFixup = ''
        #   #   wrapProgram $out/bin/vesktop \
        #   #     --add-flags "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,UseMultiPlaneFormatForHardwareVideo"
        #   # '';
        # }))
      ];
    };
  };
}
