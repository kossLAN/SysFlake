{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.dev.git;
in {
  options.programs.dev.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.git = {
        enable = true;
        userName = "kossLAN";
        userEmail = "kosslan@kosslan.dev";
        extraConfig = {
          user = {
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrZvFPiVH1pHCm5XhA3ZQCL8fUsgJQxvfqY0pbg+5NI kosslan@kosslan.dev";
          };

          gpg = {
            format = "ssh";
          };

          commit = {
            gpgsign = true;
          };
        };
      };
    };
  };
}
