{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.homebrew;
in {
  options.homebrew = {
    defaults.enable = mkEnableOption "Enable homebrew defaults";
  };

  config = mkIf cfg.defaults.enable {
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
