{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.virt.qemu;
in {
  options.virt.qemu = {
    enable = lib.mkEnableOption "qemu";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      virt-manager = {
        enable = true;
        package = pkgs.virt-manager;
      };
    };

    virtualisation = {
      libvirtd.enable = true;
    };

    users.users.${config.users.defaultUser}.extraGroups = [
      "libvirtd"
    ];
  };
}
