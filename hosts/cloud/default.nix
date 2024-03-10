{ config
, lib
, pkgs
, outputs
, inputs
, ...
}: {
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
    };
  };

  environment.etc."nc-adminpass".text = "root";
  environment.systemPackages = with pkgs; [
    git
    gh
    vim 
  ];

  boot.isContainer = true;
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 204800;
  };

  networking = {
    hostName = "cloud";
  };

  zramSwap.enable = true;
  boot.tmp.cleanOnBoot = true;

  networking.firewall = {
    allowedTCPPorts = [ 22000 8384 80 443 ];
    allowedUDPPorts = [ 21027 22000 ];
  };

  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "kosslan@kosslan.dev";
  #
  # };

  services = {
    openssh = {
      enable = true;
    };

    # nginx = {
    #   enable = true;
    #   virtualHosts."cloud.kosslan.dev" = {
    #     forceSSL = true;
    #     enableACME = true;
    #   };
    # };

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      hostName = "nextcloud.kosslan.dev";
      appstoreEnable = true;
      https = true; 

      settings = {
        trusted_domains = [ "nextcloud.kosslan.dev" ];
      };

      config = {
        adminpassFile = "/etc/nc-adminpass";
      };
    };

    syncthing = {
      enable = true;
      #openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
    };
  };

  users.users.syncthing.extraGroups = [ "nextcloud" ];
  users.users.root.initialPassword = "root";
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpkeLOreGeqUDLcrlYgzyeSSZmBvJLY+dWOeORIpGQQVRvlko8NRcVKS/fa5EHBd9HG9gRs96FK5WF9JJCGsY4ovL++WZwlsQN3xfc0xq2Sn8TQhgDgiBFCR05JDMi1+f6v9WpaiLiQnOKiTmSGYhzvayIr/XrpcAaXo0mLDEnqZbSzqTcAcqZMcPZixmkgFJA+kUq6d1Z5XMPRRTPJNmLGY0jNbVlUiI9pWsIlGqZFcMLssNWnIZkl8SCV/lN+uyFy2G1o1LlMQ6UFziqP3Zm28gq6alt7ivFJ8A8hUffiZWeQ4uURV8TKhQ43FGSUspma7DpG5zGdionkN521rQJajdnWJLO25dXRkDdXWmkwpFuKRep0m0xv0VSxXAPYs5IrFuDuylbfo6W0N5dx2sPgBK8cQ2uj5AvVCM6g8cgWh+pxzG/WV/2XpwrT7jD8vyRUL+U6FpiMQIsepJ/WQIhA7HkQnex2QHGAsu7hP5Wr5Bs33m8JYT5XCT0KsXkzQE= koss@galahad'' ];

  system.stateVersion = "23.11";
}
