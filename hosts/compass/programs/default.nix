{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    keepassxc
    nvim-pkg
  ];

  users.packages = with pkgs; [
    keepassxc
    vesktop
  ];

  programs = {
    utils.enable = true;
    syncthing.user.enable = true;
    vscodium.enable = true;

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
