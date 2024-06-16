{...}: {
  services = {
    ssh.enable = true;
    bluetooth.enable = true;
    upower.enable = true;
    libinput.enable = true;

    xserver = {
      enable = true;
      libinput.enable = true;
    };
  };
}
