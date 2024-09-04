{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [nvim-pkg];

  programs = {
    utils.enable = true;
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
