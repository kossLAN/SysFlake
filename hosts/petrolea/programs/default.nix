{config, ...}: {
  programs = {
    utils.enable = true;
    neovim.defaults.enable = true;
    dev.git.enable = true;

    zsh = {
      enable = true;
      defaults.enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };
  };
}
