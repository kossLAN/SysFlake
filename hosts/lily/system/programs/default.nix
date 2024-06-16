{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    keepassxc
    armcord
    bambu-studio
    libreoffice-qt
    mpv
    pavucontrol
  ];

  programs = {
    utils.enable = true;
    customNeovim.enable = true;
    syncthing.usermodeEnable = true;

    hyprland = {
      enable = true;
      anyrun.enable = true;
      defaults = {
        enable = true;

        additionalExecOnce = [
          #Autostart
          "[workspace 2 silent] armcord"
          "[workspace 3 silent] firefox-esr"
          "[workspace 5 silent] keepassxc"
        ];

        additionalWindowRules = [
          "workspace 2, armcord"
          "workspace 5, keepassxc"
        ];
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
