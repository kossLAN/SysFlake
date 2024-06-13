{
  inputs,
  outputs,
  pkgs,
  username,
  ...
}: {
  # TODO: SPLIT THIS MESS INTO MUTIPLE FILES

  imports = [
    ./hardware
    outputs.universalModules
    outputs.nixosModules
    inputs.secrets.secretModules
  ];

  system.defaults.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [
        "snd_aloop"
        "i2c-dev"
        "amdgpu"
      ];
    };

    kernelModules = ["kvm-amd"];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
      "amdgpu.vm_update_mode=3"
    ];

    # Cross Compilation
    binfmt.emulatedSystems = [
      "riscv32-linux"
      "riscv64-linux"
      "x86_64-windows"
      "aarch64-linux"
    ];
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/zsh";
    };

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking.nm.enable = true;

  loginmanager.greetd = {
    gtkgreet.enable = true;
  };

  theme.oled.enable = true;

  virt = {
    docker.enable = false;
    qemu.enable = true;
  };

  services = {
    tablet.enable = true;
    bluetooth.enable = true;
    ssh.enable = true;
    amdGpu.enable = true;
    helpfulUtils.enable = true;
    sound.enable = true;
    mullvad-vpn.enable = true;

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };

    udevRules = {
      enable = true;
      keyboard.enable = true;
    };
  };

  programs = {
    partition-manager.enable = true;
    noisetorch.enable = true;
    oc.enable = true;
    art.enable = true;
    customNeovim.enable = true;
    utils.enable = true;
    obs-studio.enable = true;
    syncthing.usermodeEnable = true;
    vscodium.enable = true;

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

    hyprland = {
      enable = true;
      xwayland.enable = true;
      customConf = true;
    };

    zsh = {
      enable = true;
      customConf = true;
    };

    foot = {
      enable = true;
      customConf = true;
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
