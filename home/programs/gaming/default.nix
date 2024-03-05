{ pkgs
, inputs
, self
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" ];
in
{
  imports = [
    ./mangohud
  ];

  home.packages = with pkgs; lib.mkIf (builtins.elem platform allowedPlatforms) [
    radeontop
    htop
    lutris
    prismlauncher
    ugtrain
    gamemode
    protonup-qt
    heroic
    scanmem
    yuzu-early-access
    rpcs3
    protontricks
    wine
    winetricks
    xivlauncher
    r2modman
    #inputs.nix-gaming.packages.${pkgs.system}.osu-stable
    #inputs.nix-gaming.packages.${pkgs.system}.osu-mime
    #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    #inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
    #osu-lazer
  ];
}
