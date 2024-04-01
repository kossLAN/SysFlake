{
  lib,
  config,
  ...
}: let
  cfg = config.virt.vmware;
in {
  options.virt.vmware = {
    enable = lib.mkEnableOption "vmware";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      vmware.host.enable = true;
      vmware.guest.enable = true;
      libvirtd.enable = true;
    };

    #TODO: fix user issue..
    users.users.koss.extraGroups = [
      "libvirtd"
    ];
  };
}
