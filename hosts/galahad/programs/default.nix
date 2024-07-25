{
  pkgs,
  username,
  inputs,
  ...
}: {
  users.packages = with pkgs; [
    deluge
    pavucontrol
    mpv
    via
    keepassxc
    bambu-studio
    libreoffice-qt
    plexamp
    nerdfonts

    discord
    # (vesktop.override {
    #   electron = electron_31-bin;
    # })
  ];

  programs = {
    partition-manager.enable = true;
    noisetorch.enable = true;
    oc.enable = true;
    art.enable = true;
    neovim.defaults.enable = true;
    utils.enable = true;
    obs-studio.enable = true;
    syncthing.usermodeEnable = true;
    # vscodium.enable = true;

    # sway = {
    #   enable = true;
    #   defaults.enable = true;
    # };

    # hyprland = {
    #   enable = true;
    #   xwayland.enable = true;
    #
    #   # Look into the module, this adds alot of shit
    #   defaults = {
    #     enable = true;
    #
    #     additional = {
    #       settings = {
    #         monitor = ["DP-2,preferred,auto,1.25"];
    #       };
    #
    #       exec-once = [
    #         #Autostart
    #         "[workspace 2 silent] vesktop"
    #         "[workspace 2 silent] plexamp --force-device-scale-factor=1.25"
    #         "[workspace 3 silent] firefox-esr"
    #         "[workspace 5 silent] keepassxc"
    #
    #         "noisetorch -i"
    #       ];
    #
    #       windowrules = [
    #         "workspace 2, plexamp"
    #         "workspace 2, vesktop"
    #         "workspace 5, keepassxc"
    #       ];
    #     };
    #   };
    # };

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

    foot = {
      enable = true;
      defaults.enable = true;
    };

    dev = {
      git.enable = true;
      utils.enable = true;
      java.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Unusued, but it's here when I need it
      ];
    };

    game = {
      utils.enable = true; # Misc game programs
      steam.enable = true;
      mangohud.enable = true;
    };
  };
}
