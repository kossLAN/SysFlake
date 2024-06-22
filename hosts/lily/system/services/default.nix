{...}: {
  services = {
    ssh.enable = true;
    bluetooth.enable = true;
    libinput.enable = true;
    xserver.enable = true;
    helpfulUtils.enable = true;
    upower.enable = true;

    acpid = {
      enable = true;
      lidEventCommands = ''
        systemctl suspend
      '';
    };
  };
}
