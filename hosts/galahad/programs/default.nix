{
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop
    mpv
    nvim-pkg
    via
    keepassxc
    bambu-studio
    libreoffice-qt
    # blender-hip # this is broken
    gimp
    jellyfin-media-player

    inputs.agenix.packages.${pkgs.stdenv.system}.default
  ];

  programs = {
    partition-manager.enable = true;
    corectrl.enable = true;
    common.enable = true;
    obs-studio.enable = true;
    syncthing.user.enable = true;
    zen-browser.enable = true;

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };

    hyprland = {
      enable = true;
      defaults.enable = true;
    };

    zsh = {
      enable = true;
      defaults.enable = true;
    };

    foot = {
      enable = true;
      defaults.enable = true;
    };

    noisetorch = {
      enable = true;
      device = "alsa_input.usb-RODE_Microphones_RODE_AI-1_D02E743F-00.mono-fallback";
    };

    dev = {
      git.enable = true;
      utils.enable = true;
      java.enable = true;
    };

    game = {
      utils.enable = true; # Misc game programs
      steam.enable = true;
      mangohud.enable = true;
    };
  };
}
