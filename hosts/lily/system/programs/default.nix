{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    keepassxc
    armcord
    bambu-studio
    libreoffice-qt
    mpv
    pavucontrol
    jellyfin-media-player
  ];

  programs = {
    utils.enable = true;
    customNeovim.enable = true;
    syncthing.usermodeEnable = true;
    dev.git.enable = true;

    hyprland = {
      enable = true;
      anyrun.enable = true;
      defaults = {
        enable = true;

        additional = {
          settings = {
            device = {
              name = "apple-internal-keyboard-/-trackpad-1";
              sensitivity = "0.10";
              accel_profile = "adaptive";

              tap-to-click = false;
              clickfinger_behavior = true;
              disable_while_typing = true;
            };
          };

          exec-once = [
            #Autostart
            "[workspace 2 silent] jellyfinmediaplayer"
            "[workspace 2 silent] armcord"
            "[workspace 3 silent] firefox-esr"
            "[workspace 5 silent] keepassxc"
          ];

          windowrules = [
            "workspace 2, armcord"
            "workspace 5, keepassxc"
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
  };
}
