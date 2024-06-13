{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;

  cfg = config.homebrew;
in {
  options.homebrew = {
    customConf = mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.customConf {
    homebrew = {
      onActivation.autoUpdate = true;
      onActivation.upgrade = true;
      onActivation.cleanup = "uninstall";
      # updates homebrew packages on activation,
      # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
      casks = [
        "blender"
        "steam"
        "stats"
        "firefox"
        "keepassxc"
        "dotnet"
        "adobe-creative-cloud"
        "bambu-studio"
        "via"
        "crossover"
        "microsoft-word"
        "microsoft-powerpoint"
        "microsoft-outlook"
        "microsoft-excel"
        "microsoft-teams"
        "plexamp"
      ];

      brews = [
        "java"
        "dotnet"
        "openjdk"
      ];
    };
  };
}
