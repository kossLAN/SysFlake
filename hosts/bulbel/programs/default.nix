{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpv
    nvim-pkg
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
    zen-browser.enable = true;
    partition-manager.enable = true;
    art.enable = true;
    utils.enable = true;
    obs-studio.enable = true;
    syncthing.user.enable = true;

    dev = {
      git.enable = true;
      utils.enable = true;
      java.enable = true;
    };
  };
}
