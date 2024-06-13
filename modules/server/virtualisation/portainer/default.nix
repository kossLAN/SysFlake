{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.virtualisation.portainer;
in {
  options.virtualisation.portainer = {
    enable = mkEnableOption "docker in docker management";
  };

  # Mostly used for temp services I want to try out quickly without having to configure entirely...
  config = mkIf cfg.enable {
    # networking.firewall = {
    #   allowedTCPPorts = [9000 9443];
    # };

    # Docker configuration
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
      containers.portainer = {
        image = "portainer/portainer-ce:latest";
        ports = ["127.0.0.1:9000:9000" "127.0.0.1:9443:9443"];
        volumes = [
          "portainer_data:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "portainer.kosslan.dev" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:9000/";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_ssl_server_name on;
                proxy_pass_header Authorization;
              '';
            };
          };
        };
      };
    };
  };
}
