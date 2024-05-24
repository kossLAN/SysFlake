{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.programs.hm.dev.git;
in {
  imports = [inputs.secrets.secretModules];

  options.programs.hm.dev.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.git = {
        enable = true;
        userName = "kossLAN";
        userEmail = "kosslan@kosslan.dev";
      };

      programs.gh = {
        enable = true;
        gitCredentialHelper = {
          enable = true;
          hosts = ["https://github.com" "https://git.kosslan.dev"];
        };
      };

      # Default git key.
      home.file.".ssh/id_ed25519".text = config.secrets.git1.privateKey;
    };
  };
}
