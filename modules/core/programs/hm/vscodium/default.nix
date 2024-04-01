{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.programs.hm.vscodium;
in
{
  options.programs.hm.vscodium = {
    enable = lib.mkEnableOption "vscodium";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.defaultUser} = {
      programs.vscode = {
        package = pkgs.vscodium;
        enable = true;
        mutableExtensionsDir = true;
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          catppuccin.catppuccin-vsc
          dbaeumer.vscode-eslint
          eamodio.gitlens
          esbenp.prettier-vscode
          ms-python.python
          # ms-python.vscode-pylance
          naumovs.color-highlight
          oderwat.indent-rainbow
          pkief.material-product-icons
          #pkief.material-icon-theme
          oderwat.indent-rainbow
          usernamehw.errorlens
          ms-azuretools.vscode-docker
          ms-dotnettools.csharp
          redhat.java
          llvm-vs-code-extensions.vscode-clangd
          jnoortheen.nix-ide
          ms-vscode-remote.remote-ssh
          asvetliakov.vscode-neovim
          ziglang.vscode-zig
        ];

        keybindings = [
          {
            key = "ctrl+c";
            command = "editor.action.clipboardCopyAction";
            when = "textInputFocus";
          }
          {
            key = "alt+tab";
            command = "workbench.action.quickOpenLeastRecentlyUsedEditorInGroup";
            when = "!act iveEditorGroupEmpty";
          }
          {
            key = "alt+tab";
            command = "workbench.action.quickOpenNavigatePreviousInEditorPicker";
            when = "inEditorsPicker && inQuickOpen";
          }
          {
            key = "ctrl+e";
            command = "cursorMove";
            args = {
              to = "up";
              by = "line";
              value = 10;
            };
            when = "editorTextFocus";
          }
          {
            key = "ctrl+d";
            command = "cursorMove";
            args = {
              to = "down";
              by = "line";
              value = 10;
            };
            when = "editorTextFocus";
          }
        ];

        userSettings = {
          # breadcrumbs.enabled = false;
          emmet.useInlineCompletions = true;
          security.workspace.trust.enabled = false;
          black-formatter.path = lib.getExe pkgs.black;
          stylua.styluaPath = lib.getExe pkgs.stylua;
          dotnet.server.useOmnisharp = true;
          #omnisharp.useModernNet = true;
          #omnisharp.dotnetPath = "${pkgs.dotnet-sdk}";
          #omnisharp.path = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
          # zig = {
          #   zls.path = "${pkgs.zls}/bin/zls";
          #   path = "${pkgs.zig}/bin/zig";
          # };
          "zig.initialSetupDone" = true;
          "zig.zls.path" = "";
          "zig.path" = "";
          java.jdt.ls.java.home = pkgs.temurin-bin;
          C_Cpp.vcFormat.indent.braces = true;
          C_Cpp.vcFormat.indent.accessSpecifiers = true;
          clangd.path = "${pkgs.ccls}/bin/ccls";
          html.validate.styles = false;
          css.completion.triggerPropertyValueCompletion = true;
          css.lint.unknownAtRules = "ignore";
          python.languageServer = "Jedi";
          nix.enableLanguageServer = true;
          nix.serverPath = "${pkgs.nil}/bin/nil";
          extensions.experimental.affinity = {
            "asvetliakov.vscode-neovim" = 1;
          };

          "[c]".editor.defaultFormatter = "xaver.clang-format";
          "[cpp]".editor.defaultFormatter = "xaver.clang-format";
          "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
          "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
          "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
          "[python]".editor = {
            defaultFormatter = "ms-python.black-formatter";
            formatOnType = true;
          };

          editor = {
            cursorBlinking = "smooth";
            cursorSmoothCaretAnimation = "on";
            cursorWidth = 2;
            find.addExtraSpaceOnTop = false;
            fontFamily = "'JetBrainsMono Nerd Font'";
            fontSize = 16;
            formatOnSave = true;
            inlayHints.enabled = "off";
            inlineSuggest.enabled = true;
            largeFileOptimizations = false;
            lineNumbers = "on";
            linkedEditing = true;
            maxTokenizationLineLength = 60000;
            minimap.enabled = false;
            overviewRulerBorder = false;
            quickSuggestions.strings = true;
            renderWhitespace = "none";
            renderLineHighlight = "all";
            smoothScrolling = true;
            suggest.showStatusBar = true;
            suggestSelection = "first";

            bracketPairColorization = {
              enabled = true;
              independentColorPoolPerBracketType = true;
            };

            guides = {
              bracketPairs = true;
              indentation = true;
            };
          };

          files = {
            eol = "\n";
            insertFinalNewline = true;
            trimTrailingWhitespace = true;
          };

          git = {
            autofetch = true;
            confirmSync = false;
            enableSmartCommit = true;
          };

          window.titleBarStyle = "custom";

          catppuccin.accentColor = "blue";
          workbench = {
            colorTheme = "Catppuccin Frappé";
            iconTheme = "material-icon-theme";
            list.smoothScrolling = true;
            panel.defaultLocation = "bottom";
            productIconTheme = "material-product-icons";
            smoothScrolling = true;
          };
        };
      };
    };
  };
}
