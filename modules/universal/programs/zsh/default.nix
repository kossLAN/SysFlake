{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.zsh;
in {
  options.programs.zsh = {
    customConf = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.customConf {
    # users.defaultUserShell = pkgs.zsh;

    home-manager.users.${config.users.defaultUser} = {
      programs.zsh = let
        # Oh My Zsh has alot of good plugins, thankfully we can use them without needing oh-my-zsh!
        oh-my-zsh = pkgs.fetchFromGitHub {
          owner = "ohmyzsh";
          repo = "ohmyzsh";
          rev = "fd01fd66ce27c669e5ffaea94460a37423d1e134";
          sha256 = "sha256-5G96Iae543/CVmwRVpwAlbRB7vf+t/E2fl0pOu+RM6Y=";
        };
      in {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        envExtra = ''
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
        '';

        plugins = [
          {
            file = "jovial.zsh-theme";
            name = "jovial";
            src = pkgs.fetchFromGitHub {
              owner = "zthxxx";
              repo = "jovial";
              rev = "701ea89b6dd2b9859dab32bd083a16643b338b47";
              sha256 = "sha256-VVGBG0ZoL25v+Ht1QbnZMc1TqTiJvr211OvyVwNc3bc=";
            };
          }

          # These are all plugins required by jovial...
          {
            file = "plugins/git/git.plugin.zsh";
            name = "git";
            src = oh-my-zsh;
          }
          {
            file = "plugins/urltools/urltools.plugin.zsh";
            name = "urltools";
            src = oh-my-zsh;
          }
          {
            file = "plugins/bgnotify/bgnotify.plugin.zsh";
            name = "bgnotify";
            src = oh-my-zsh;
          }
          {
            file = "zsh-history-enquirer.plugin.zsh";
            name = "zsh-history-enquirer";
            src = pkgs.fetchFromGitHub {
              owner = "zthxxx";
              repo = "zsh-history-enquirer";
              rev = "6fdfedc4e581740e7db388b36b5e66f7c86e8046";
              sha256 = "sha256-/RGBIoieqexK2r4onFbXAt4ALEIb17mn/all0P1xFkE=";
            };
          }
          {
            file = "zsh-syntax-highlighting.zsh";
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
              sha256 = "sha256-4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
            };
          }
        ];
      };
    };
  };
}
