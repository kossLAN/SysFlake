{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  virt = {
    docker.enable = true;
    qemu.enable = true;
  };

  networking = {
    networkmanager.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    ssh.enable = true;
    amdGpu.enable = true;
    helpfulUtils.enable = true;
    sound.enable = true;

    # Home-Manager module wrapper for i3
    xserver = {
      windowManager.i3 = {
        enable = true;
        defaults = {
          enable = true;
          addtional = {
            startup = [
              {
                always = true;
                command = "discord";
                notification = false;
                workspace = "1: social";
              }
              {
                always = true;
                command = "plexamp";
                notification = false;
                workspace = "1: social";
              }
              {
                always = true;
                command = "firefox-esr";
                notification = false;
                workspace = "2: web";
              }
              {
                always = true;
                command = "keepassxc";
                notification = false;
                workspace = "3: passwords";
              }
            ];

            assigns = {
              "1: social" = [{class = "^Plexamp$";} {class = "^discord$";}];
              "3: passwords" = [{class = "^KeePassXC$";}];
            };
          };
        };
      };
    };

    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };

    # desktopManager = {
    #   plasma6.enable = true;
    #   cosmic.enable = true;
    # };

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };

    udevRules = {
      enable = true;
      keyboard.enable = true;
    };
  };
}
