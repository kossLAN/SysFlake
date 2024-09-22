# This is a abstraction to route traffic from home server out to the internet via vps.
{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;

  cfg = config.routing;
in {
  options.routing = {
    services = mkOption {
      type = lib.types.listOf (lib.types.attrsOf (lib.types.str));
      description = ''
        List of services, each with attributes:
          - `interface`: The network interface to apply iptables rules (e.g., "vmbr0")
          - `proto`: The internet protocol to use (e.g., "tcp","udp")
          - `dport`: The destination port range (e.g., "24:3127")
          - `ipAddress`: The destination IP address (e.g., "192.168.1.2")
      '';
      default = [];
    };
  };

  config = {
    networking.firewall.extraCommands = let
      preroutingRules =
        lib.concatMapStrings (service: ''
          iptables -t nat -A PREROUTING -i ${service.interface} -p ${service.proto} --dport ${service.dport} -j DNAT --to ${service.ipAddress}
        '')
        cfg.services;
    in
      preroutingRules
      + ''
        iptables -t nat -A POSTROUTING -j MASQUERADE
      '';
  };
}
