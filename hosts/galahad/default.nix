{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
{
  imports = [
    ./core
    inputs.nix-gaming.nixosModules.pipewireLowLatency # From nix-gaming
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
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 1d";

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
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

  # Hardware
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    opentabletdriver.enable = true;
  };

  # Systemd
  systemd = {
    tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  }; 

  # Services
  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      videoDriver = "amdgpu";
      layout = "us";
      xkbVariant = "";  
      
      # Not my daily driver just here for comparisons and fallback
      displayManager = {
        sddm = {
          enable = false;
          wayland.enable = true;
          #theme = "chili";
        };
      };

      desktopManager = {
        plasma5.enable = false;
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
     
      lowLatency = {
        # enable this module
        enable = true;
        # defaults (no need to be set unless modified)
        quantum = 256;
        rate = 44100;
      };
    };

    openssh.settings = {
      enable = false;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };

    udev.packages = with pkgs; [
      via
    ];

    blueman.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    dbus.enable = true;
    flatpak.enable = true;
  }; 

  # Programs
  programs = {
    fish.enable = true;
    dconf.enable = true;
    gamemode.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        v8
      ];
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    java = {
      enable = true;
      package = pkgs.openjdk;
    };

    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  # Environment
  environment = {
    variables = rec {
      "DXVK_ASYNC" = "1";
    };

    sessionVariables = rec {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/fish";
      DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      FLAKE = "/home/koss/.nixos-conf";
    };

    systemPackages = with pkgs; [
      ntfs3g
      networkmanager
      scanmem
      sddm-chili-theme
    ];

    localBinInPath = true;
    enableDebugInfo = true;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "galahad";
  };

  # Security
  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  # Virtualization
  virtualisation = {
    vmware.host.enable = true;
    vmware.guest.enable = true;
    docker.enable = true;
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    libvirtd.enable = true;
  };

  # Users
  users.users = {
    koss = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "root";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        #Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "dialout"
        "docker"
        "pipewire" 
      ];
    };
  };

  system.stateVersion = "23.11";
}
