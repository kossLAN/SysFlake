{
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.dev.git;
in {
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
          hosts = ["https://github.com" "https://github.example.com"];
        };
      };
    };
  };
}
