{...}: {
  virtualisation = {
    portainer = {
      enable = true;
      openFirewall = true;
    };
  };

  services = {
    ssh = {
      enable = true;
    };
  };
}
