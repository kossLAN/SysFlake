{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.virtualisation.portainer;
in {
  options.virtualisation.portainer = {
    enable = mkEnableOption "Docker Web UI";

    reverseProxy = {
      enable = mkEnableOption "Enable the reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  # Mostly used for temp services I want to try out quickly without having to configure entirely...
  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
      };

      oci-containers = {
        backend = "docker";
        containers.portainer = {
          image = "portainer/portainer-ce:latest";
          ports = ["0.0.0.0:9000:9000" "0.0.0.0:9443:9443"];
          volumes = [
            "portainer_data:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
        };
      };
    };

    networking = mkIf cfg.reverseProxy.enable {
      firewall.allowedTCPPorts = [80 443];
    };

    services.caddy = mkIf cfg.reverseProxy.enable {
      enable = true;
      virtualHosts."portainer.${cfg.reverseProxy.domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:9000
      '';
    };
  };
}
