{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.hyprland.anyrun;
in {
  options.programs.hyprland.anyrun = {
    enable = mkEnableOption "Enable anyrun for use in Hyprland";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      imports = [inputs.anyrun.homeManagerModules.default];

      programs.anyrun = let
        anyrun-pkgs = inputs.anyrun.packages.${pkgs.system};
      in {
        enable = true;

        config = {
          x = {fraction = 0.5;};
          y = {absolute = 0;};
          width = {absolute = 500;};
          height = {absolute = 0;};
          hideIcons = false;
          ignoreExclusiveZones = false;
          layer = "overlay";
          hidePluginInfo = false;
          closeOnClick = true;
          showResultsImmediately = true;
          maxEntries = null;

          plugins = with anyrun-pkgs; [
            applications
            shell
            websearch
          ];
        };

        extraConfigFiles = {
          "shell.ron".text = ''
            Config(
              prefix: ":sh",
              shell: None,
            )
          '';

          "websearch.ron".text = ''
            Config(
              prefix: "?",
              Custom(
                name: "Searx",
                url: "search.kosslan.dev/?q={}",
              )
              engines: [Custom]
            )
          '';
        };

        extraCss = ''
          * {
            all: unset;
            font-size: 1rem;
          }

          #window,
          #match,
          #entry,
          #plugin,
          #main {
            background: transparent;
          }

          #match.activatable {
            border-radius: 5px;
            padding: 0.3rem 0.9rem;
            margin-top: 0.01rem;
          }
          #match.activatable:first-child {
            margin-top: 0.7rem;
          }
          #match.activatable:last-child {
            margin-bottom: 0.6rem;
          }

          #plugin:hover #match.activatable {
            border-radius: 0px;
            padding: 0.3rem;
            margin-top: 0.01rem;
            margin-bottom: 0;
          }

          #match:selected,
          #match:hover,
          #plugin:hover {
            background: #323437;
            /* background: rgba(255, 255, 255, .1); */
          }

          #match:selected {
            color: @theme_bg_color;
            background: #99c1f1;
            border-radius: 5px;
          }

          #entry {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            margin: 0.3rem;
            padding: 0.3rem 1rem;
          }

          list > #plugin {
            border-radius: 16px;
            margin: 0 0.3rem;
          }
          list > #plugin:first-child {
            margin-top: 0.3rem;
          }
          list > #plugin:last-child {
            margin-bottom: 0.3rem;
          }
          list > #plugin:hover {
            padding: 0.6rem;
          }

          box#main {
            color: @theme_fg_color;
            border: 1px solid #ffffff;
            margin-top: 15px;
            background-color: @theme_bg_color;
            border-radius: 5px;
            padding: 0.3rem;
          }
        '';
      };
    };
  };
}
