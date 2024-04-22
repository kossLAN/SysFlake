{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.searx;
in {
  options.services.searx.customConf = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.customConf.enable {
    services.searx = {
      redisCreateLocally = true;
    };

    # NGINX
  };
}
