# Alot of the inspiration and part of the implementation is largely due in part to outfoxxed
# great dev and was gracious enough to let me him copy him here.
{
  lib,
  config,
  deployment,
  ...
}: let
  inherit (lib.options) mkOption;

  uidmap = import ./uids.nix;

  containerNames = builtins.attrNames config.deployment.containers;
in {
  options.deployment = {
    # deployment.containers.<name>.owner to declare a container
    containers = mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.owner = mkOption {
          type = lib.types.str;
          default = "root";
        };
      });

      default = {};
    };

    tailnetDomain = mkOption {
      type = lib.types.str;
      default = "ts.net";
    };

    tailnetSubdomains = mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = {
    _module.args.deployment = let
      indexOf = list: elem: let
        f = f: i:
          if i == (builtins.length list)
          then null
          else if (builtins.elemAt list i) == elem
          then i
          else f f (i + 1);
      in
        f f 0;
    in {
      # Adds a subdomain to tailscale dns records
      tailnetFqdnList =
        builtins.map
        (subdomain: "${subdomain}.${config.deployment.tailnetDomain}")
        config.deployment.tailnetSubdomains;

      # Using containers list, we give our containers ips based off their index in the list
      # First container in list will be 192.168.100.11, then auto incrementing from there, this
      # meaning that IP's for containers will probably change fairly rapidly, so they SHOULD not
      # called via a regular string. ie doing ip = "192.168.100.11"; BAD!
      containerHostIp = container: let
        index = indexOf containerNames container;
      in
        assert index != null; "192.168.100.${builtins.toString (index + 11)}";

      serviceUID = service: uidmap.uidmap.${service};
      serviceGID = service: uidmap.gidmap.${service};
    };

    # Example usuage of this
    # home-manager.users.${config.users.defaultUser} = {
    #   home.file."test.txt".text = ''
    #     ${builtins.toString (deployment.serviceUID "test")}
    #   '';
    # };
  };
}
