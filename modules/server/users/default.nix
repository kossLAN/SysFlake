{pkgs, ...}: {
  config = {
    programs.zsh = {
      enable = true;
      shellInit = "autoload -Uz add-zsh-hook";
    };

    users = {
      defaultUserShell = pkgs.zsh;
    };
  };
}
