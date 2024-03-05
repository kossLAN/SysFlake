{ pkgs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  # Really don't need most of this here, its really just bloat but I'm lazy :p
  home.packages = with pkgs; [
    boost 
    python3
    # (python3.withPackages (python-pkgs: [
    #   python-pkgs.pandas
    #   python-pkgs.requests
    #   python-pkgs.bitsandbytes
    #   python-pkgs.transformers
    #   python-pkgs.torchWithRocm
    # ]))
    conda
    # libvirequests 
    ffmpeg
    libffi.dev
    libffi
    glfw
    libopus
    libopus.dev
    # libGL
    # libGL.dev
    #libglvnd
    # glm
    # libGLU
  ];
}
