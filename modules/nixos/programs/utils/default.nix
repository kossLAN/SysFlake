{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.utils;
in {
  # Common apps...
  options.programs.utils = {
    enable = lib.mkEnableOption "Basic Utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        deluge
        pavucontrol
        mpv
        via
        keepassxc
        bambu-studio
        libreoffice-qt
        plexamp
        vesktop

        # (vesktop.overrideAttrs (old: {
        #   postFixup = ''
        #     wrapProgram $out/bin/vesktop \
        #       --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-zero-copy --use-gl=angle --use-vulkan --enable-oop-rasterization --enable-raw-draw --enable-gpu-rasterization --enable-gpu-compositing --enable-native-gpu-memory-buffers --enable-accelerated-2d-canvas --enable-accelerated-video-decode --enable-accelerated-mjpeg-decode --disable-gpu-vsync --enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport, VaapiVideoDecodeLinuxGL,VaapiVP8Encoder,VaapiVP9Encoder,VaapiAV1Encoder"
        #   '';
        # }))
      ];
    };
  };
}
