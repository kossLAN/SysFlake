{ inputs
, outputs
, config
, lib
, stateVersion
, pkgs
, #, username
  hostname
, platform
, homeDir
, ...
}: {
  imports = [
    ./desktop
    ./programs
    ./packages
    ./scripts
    ./theme

    outputs.homeManagerModules.nvim
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  home = {
    username = "koss";
    homeDirectory = homeDir;
  };

  programs.home-manager.enable = true;
  programs.nvim.enable = true;

  systemd.user.startServices = lib.mkIf (platform == "desktop") "sd-switch";
  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "23.11";
}
