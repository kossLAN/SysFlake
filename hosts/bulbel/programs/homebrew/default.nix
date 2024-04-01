{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "uninstall";
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "blender"
      "kicad"
      "steam"
      "stats"
      "vmware-fusion"
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
    ];

    brews = [
      "java"
      "openjdk"
    ];
  };
}
