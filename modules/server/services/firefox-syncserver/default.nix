{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.firefox-syncserver;
in {
  options.services.firefox-syncserver = {
    defaults = {
      enable = mkEnableOption "Firefox sync server configuration";
    };

    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy for Firefox sync server";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [80 443];
      };
    };

    services = {
      mysql = mkIf cfg.defaults.enable {
        package = pkgs.mariadb;
      };

      firefox-syncserver = mkIf cfg.defaults.enable {
        singleNode = {
          url = "https://firefox.kosslan.dev";
          hostname = "localhost";
          enable = true;
          capacity = 5;
        };

        settings = {
          tokenserver.enabled = true;
          port = 5000;
        };

        database = {
          createLocally = true;
        };
      };

      caddy = mkIf cfg.reverseProxy.enable {
        enable = true;
        virtualHosts."portainer.${cfg.reverseProxy.domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:5000
        '';
      };
    };
  };
}
