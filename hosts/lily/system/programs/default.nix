{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    keepassxc
    vesktop
    bambu-studio
    libreoffice-qt
    mpv
    pavucontrol
  ];

  programs = {
    utils.enable = true;
    customNeovim.enable = true;

    hyprland = {
      enable = true;
      anyrun.enable = true;
      defaults = {
        enable = true;
        additionalSettings = {
          exec-once = [
            #Autostart
            "[workspace 2 silent] vesktop"
            "[workspace 3 silent] firefox-esr"
            "[workspace 5 silent] keepassxc"
          ];
        };
      };
    };

    foot = {
      enable = true;
      customConf = true;
    };

    zsh = {
      enable = true;
      customConf = true;
    };

    firefox = {
      enable = true;
      customPreferences = true;
      customExtensions = true;
      customPolicies = true;
      customSearchEngine = true;
    };

    dev.git.enable = true;
  };
}
