{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.virtualisation.flaresolverr;
in {
  options.virtualisation.flaresolverr = {
    enable = mkEnableOption "Cloudflare bypass";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.flaresolverr = {
        image = "flaresolverr/flaresolverr:latest";
        ports = ["127.0.0.1:8191:8191"];
        volumes = [
          "portainer_data:/data"
        ];
      };
    };
  };
}
