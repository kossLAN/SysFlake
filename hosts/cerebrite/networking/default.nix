{...}: {
  services = {
    tailscale.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
