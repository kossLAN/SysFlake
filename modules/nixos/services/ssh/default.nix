{
  lib,
  config,
  ...
}: let
  cfg = config.services.ssh;
in {
  options.services.ssh = {
    enable = lib.mkEnableOption "ssh";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.settings = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };
}
