{
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpv
    nvim-pkg
  ];

  users.packages = with pkgs; [
    pavucontrol
    via
    keepassxc
    bambu-studio
    libreoffice-qt
    nerdfonts
    vesktop

    inputs.agenix.packages.${pkgs.stdenv.system}.default
  ];

  programs = {
    vscodium.enable = true;
    partition-manager.enable = true;
    art.enable = true;
    utils.enable = true;
    obs-studio.enable = true;
    syncthing.user.enable = true;

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
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

    dev = {
      git.enable = true;
      utils.enable = true;
      java.enable = true;
    };
  };
}
