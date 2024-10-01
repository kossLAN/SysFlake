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
    pavucontrol
    via
    keepassxc
    bambu-studio
    libreoffice-qt
    blender-hip
    gimp

    inputs.agenix.packages.${pkgs.stdenv.system}.default
  ];

  programs = {
    partition-manager.enable = true;
    noisetorch.enable = true;
    oc.enable = true;
    common.enable = true;
    obs-studio.enable = true;
    syncthing.user.enable = true;

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };

    hyprland = {
      enable = true;
      defaults.enable = true;
    };

    firefox = {
      enable = true;
      customPreferences = true;
      customExtensions = true;
      customPolicies = true;
      customSearchEngine = true;
    };

    zsh = {
      enable = true;
      defaults.enable = true;
    };

    foot = {
      enable = true;
      defaults.enable = true;
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
