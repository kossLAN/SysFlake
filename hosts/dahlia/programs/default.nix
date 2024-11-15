{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nvim-pkg
  ];

  programs = {
    dev.git.enable = true;
    common.enable = true;

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };
  };
}
