{
  username,
  pkgs,
  ...
}: {
  programs = {
    utils.enable = true;
    neovim.defaults.enable = true;
    syncthing.usermodeEnable = true;
    vscodium.enable = true;

    nh = {
      enable = true;
      flake = "/home/${username}/.nixos-conf";
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
    };

    game = {
      utils.enable = true; # Misc game programs
      #mangohud.enable = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };
}
