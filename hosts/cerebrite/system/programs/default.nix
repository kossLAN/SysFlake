{username, ...}: {
  programs = {
    utils.enable = true;
    customNeovim.enable = true;
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
