{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware
    outputs.universalModules
    outputs.nixosModules
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 1d";

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # Internationalisation and Timezone
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Boot
  boot = {
    # Bootloader
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    loader.grub = {
      efiSupport = true;
      enable = true;
      device = "nodev";
      useOSProber = true;
    };

    # Cross Compilation
    binfmt.emulatedSystems = [
      "riscv32-linux"
      "riscv64-linux"
      "x86_64-windows"
      "aarch64-linux"
    ];
  };

  environment = {
    variables = {
      "DXVK_ASYNC" = "1";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/zsh";
      FLAKE = "/home/koss/.nixos-conf";
    };

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking = {
    nm.enable = true;
    hostName = hostname;
  };

  loginmanager.greetd = {
    gtkgreet.enable = true;
  };

  theme.oled.enable = true;

  virt = {
    docker.enable = true;
    qemu.enable = true;
    vmware.enable = false;
  };

  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };

    tablet.enable = true;
    bluetooth.enable = true;
    ssh.enable = true;

    amdGpu.enable = true;
    helpfulUtils.enable = true;
    sound.enable = true;
    mullvad-vpn.enable = true;

    udevRules = {
      enable = true;
      keyboard.enable = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      customConf.enable = true;
    };

    noisetorch.enable = true;
    devTools.enable = true;
    gameUtils.enable = true;
    oc.enable = true;
    zsh = {
      enable = true;
      customConf = true;
    };

    hm = {
      art.enable = true;
      foot.enable = true;
      nvim.enable = true;
      utils.enable = true;
      obs-studio.enable = true;
      syncthing.enable = true;
      vscodium.enable = true;

      dev = {
        git.enable = true;
        utils.enable = true;
      };

      game = {
        enable = true;
        mangohud.enable = true;
      };
    };
  };

  system.stateVersion = "23.11";
}
