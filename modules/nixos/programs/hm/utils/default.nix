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
        (vesktop.overrideAttrs
          (old: {
            patches = (old.patches or []) ++ [./readonlyFix.patch];

            src = fetchFromGitHub {
              rev = "0cfb1f643ced8cd53f3100d9f9014e77f4e538cf";
              hash = "sha256-k/k5mZpfIrThVwgzB4OgL6txfnWMQ2e7uAXO763PnLM=";
              owner = "Vencord";
              repo = "Vesktop";
            };

            postFixup = ''
              wrapProgram $out/bin/vesktop \
                --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-zero-copy --use-gl=angle --use-vulkan --enable-oop-rasterization --enable-raw-draw --enable-gpu-rasterization --enable-gpu-compositing --enable-native-gpu-memory-buffers --enable-accelerated-2d-canvas --enable-accelerated-video-decode --enable-accelerated-mjpeg-decode --disable-gpu-vsync --enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport, VaapiVideoDecodeLinuxGL,VaapiVP8Encoder,VaapiVP9Encoder,VaapiAV1Encoder"
            ''; # Vulkan stuff is left here because we want to make --use-angle=vulkan work.
          }))
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
