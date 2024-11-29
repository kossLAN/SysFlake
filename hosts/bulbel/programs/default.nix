{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpv
    keepassxc
    bambu-studio
    libreoffice-qt
    prismlauncher
    vesktop

    inputs.agenix.packages.${pkgs.stdenv.system}.default
  ];

  programs = {
    zen-browser.enable = true;
    partition-manager.enable = true;
    common.enable = true;
    java.enable = true;
    git.enable = true;
    obs-studio.enable = true;
    foot.enable = true;

    hyprland = {
      enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };

    custom-neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
