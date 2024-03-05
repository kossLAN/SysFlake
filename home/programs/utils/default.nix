{ pkgs
, inputs
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  home.packages = with pkgs; [
    pavucontrol
    mpv
    firefox
    protonup-ng
    gnome.eog
    cinnamon.nemo-with-extensions
    via
    spotify
    ddcui
    virt-manager
    keepassxc
    thunderbird
    BeatSaberModManager
    bambu-studio
    hplip
    libreoffice-qt
    wootility
    vesktop
    nh
    #inputs.nh.packages.${pkgs.system}.default
    # (pkgs.armcord.overrideAttrs (old: {
    #     postFixup = ''
    #       wrapProgram $out/bin/armcord \
    #         --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    #     '';
    #   }))
  ];
}
