{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.services.ssh;
in {
  imports = [inputs.secrets.secretModules];

  options.services.ssh = {
    enable = lib.mkEnableOption "ssh";
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.users.defaultUser}.openssh.authorizedKeys.keys = [
      config.secrets.ssh1.publicKey
    ];

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    home-manager.users.${config.users.defaultUser} = {
      home.file.".ssh/config".text = ''
        Host cerebrite
          HostName 147.135.1.68
          User koss
          Port 1000
      '';

      home.file.".ssh/id_rsa".text = config.secrets.ssh1.privateKey;
    };
  };
}
