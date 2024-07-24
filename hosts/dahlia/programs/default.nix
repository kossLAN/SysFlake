{username, ...}: {
  programs = {
    utils.enable = true;
    neovim.defaults.enable = true;
    dev.git.enable = true;

    zsh = {
      enable = true;
      customConf = true;
    };

    nh = {
      enable = true;
      flake = "/home/${username}/.nixos-conf";
    };
  };
}
