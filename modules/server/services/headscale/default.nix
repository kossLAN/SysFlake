{
  config,
  lib,
  pkgs,
  deployment,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.headscale;
in {
  options.services.headscale = {
    defaults.enable = mkEnableOption ''
      Enable opinionated defaults for headscale
      warning: this will overwrite the NixOS modules settings COMPLETELY
    '';

    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy for headscale";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
        description = "Domain name for headscale";
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [config.services.headscale.package];

      # NixOS Module is shit, gg go next
      # This was a outfoxxed idea, I just stole it
      etc."headscale/config.yaml".source =
        mkIf cfg.defaults.enable
        (lib.mkForce (import ./config.nix {
          inherit config pkgs deployment;
        }));
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.reverseProxy.enable [80 443];

    services = {
      caddy = mkIf cfg.reverseProxy.enable {
        enable = true;
        virtualHosts = {
          "ts.${cfg.reverseProxy.domain}".extraConfig = ''
            reverse_proxy http://127.0.0.1:3442
          '';
        };
      };
    };
  };
}
