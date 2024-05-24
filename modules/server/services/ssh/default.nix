{
  lib,
  config,
  ...
}: let
  cfg = config.services.ssh;
  sshPort = 1000;
in {
  options.services.ssh = {
    enable = lib.mkEnableOption "ssh";
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.users.defaultUser}.openssh.authorizedKeys.keys = [config.secrets.ssh1.publicKey];

    networking = {
      firewall = {
        allowedTCPPorts = [sshPort];
      };
    };

    services.openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = sshPort;
        }
      ];
      ports = [sshPort];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    home-manager.users.${config.users.defaultUser} = {
      home.file.".ssh/id_rsa".text = config.secrets.ssh1.privateKey;
    };
  };
}
