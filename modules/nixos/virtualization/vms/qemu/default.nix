{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.virt.qemu;
in {
  options.virt.qemu = {
    enable = mkEnableOption "qemu";
  };

  config = mkIf cfg.enable {
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
