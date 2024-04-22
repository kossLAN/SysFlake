{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.virtualisation.portainer;
in {
  options.virtualisation.portainer = {
    enable = lib.mkEnableOption "docker in docker management";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [9000 9443];
    };

    virtualisation.oci-containers = {
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
}
