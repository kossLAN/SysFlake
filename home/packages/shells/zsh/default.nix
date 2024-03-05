{ platform
, lib
, ...
}: let
  allowedPlatforms = [ "desktop" "macbook" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/zsh-custom";
      plugins = [
        "git" 
        "urltools"
        "bgnotify"
        "zsh-syntax-highlighting"
        "zsh-history-enquirer"
        "jovial"
      ];
      # https://github.com/zthxxx/jovial <---- Good theme
      theme = "jovial";
    };
  };

  home.file.".config/zsh-custom".source = ./custom;
}
