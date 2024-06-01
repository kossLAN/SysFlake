{
  lib,
  config,
  ...
}: let
  cfg = config.programs.dev.git;
in {
  options.programs.dev.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.git = {
        enable = true;
        userName = "kossLAN";
        userEmail = "kosslan@kosslan.dev";
      };

      # Default git key.
      home.file.".ssh/id_ed25519".text = config.secrets.git1.privateKey;
    };
  };
}
