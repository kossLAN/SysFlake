{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop
    keepassxc
    nvim-pkg
  ];

  programs = {
    utils.enable = true;
    syncthing.user.enable = true;
    zen-browser.enable = true;

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };

    dev = {
      git.enable = true;
    };

    game = {
      utils.enable = true; # Misc game programs
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };
}
