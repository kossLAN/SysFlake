{
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.ssh;
in {
  options.programs.hm.ssh = {
    importKeys = lib.mkEnableOption "Import key files";
    importConfig = lib.mkEnableOption "Import config";
  };

  config = {
    home-manager.users.${config.users.defaultUser} = {
      home.file = {
        ".ssh/config".text = lib.mkIf cfg.importConfig ''
          Host cerebrite
            HostName 147.135.1.68
            User koss
            Port 1000
        '';

        ".ssh/id_rsa".text = lib.mkIf (cfg.importKeys) config.secrets.ssh1.privateKey;
        ".ssh/id_rsa.pub".text = lib.mkIf (cfg.importKeys) config.secrets.ssh1.publicKey;
      };
    };
  };
}
