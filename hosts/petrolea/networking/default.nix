{...}: let
  external-mac = "3c:ec:ef:30:10:3d";
  ext-if = "eno4";
  external-ip = "185.150.189.28";
  external-gw = "185.150.189.1";
  external-netmask = 24;
in {
  services = {
    # headscale = {
    #   enable = true;
    #   defaults.enable = true;
    #   reverseProxy.enable = true;
    # };

    tailscale = {
      enable = true;
    };

    udev.extraRules = ''SUBSYSTEM=="net", ATTR{address}=="${external-mac}", NAME="${ext-if}"'';
  };

  networking = {
    nameservers = ["1.1.1.1" "8.8.8.8"];

    interfaces = {
      "${ext-if}" = {
        ipv4.addresses = [
          {
            address = external-ip;
            prefixLength = external-netmask;
          }
        ];
      };
    };

    defaultGateway = external-gw;
  };
}
