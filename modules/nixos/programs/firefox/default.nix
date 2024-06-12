{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.firefox;
in {
  options.programs.firefox = {
    customExtensions = lib.mkEnableOption "A list of firefox extenions to install.";
    customPreferences = lib.mkEnableOption "A list of firefox preferences to install.";
    customPolicies = lib.mkEnableOption "A list of firefox policies that I like to enable";
    customSearchEngine = lib.mkEnableOption "Personal search engine, that I want to default to";
  };

  config = {
    programs.firefox = {
      package = pkgs.firefox-esr;
      policies = {
        # Default policies - these shouldn't be opt out :/
        OverrideFirstRunPage = "";
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFormHistory = true;
        DisplayBookmarksToolbar = true;
        DontCheckDefaultBrowser = true;
        DisableSetDesktopBackground = true;
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        PromptForDownloadLocation = true;
        NoDefaultBookmarks = true;

        # Additional policies
        EnableTrackingProtection = lib.mkIf cfg.customPolicies {
          Cryptomining = true;
          Fingerprinting = true;
          Locked = true;
          Value = true;
        };

        FirefoxHome = lib.mkIf cfg.customPolicies {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };

        UserMessaging = lib.mkIf cfg.customPolicies {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };

        Cookies = lib.mkIf cfg.customPolicies {
          Behavior = "accept";
          ExpireAtSessionEnd = false;
          Locked = false;
        };

        # Search Engine
        SearchEngines = lib.mkIf cfg.customSearchEngine {
          Add = [
            {
              Name = "Searx";
              Description = "Searx";
              Alias = "!sx";
              Method = "GET";
              URLTemplate = "https://search.kosslan.dev/search?q={searchTerms}";
            }
            {
              Name = "nixpkgs";
              Description = "Nixpkgs query";
              Alias = "!nix";
              Method = "GET";
              URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
            }
          ];
          Default = "Searx";
        };

        # Declarative Extensions
        ExtensionSettings = lib.mkIf cfg.customExtensions {
          "uBlock0@raymondhill.net" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
          "sponsorBlocker@ajay.app" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          };
          "user-agent-switcher@ninetailed.ninja" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
          };
          "keepassxc-browser@keepassxc.org" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          };
        };
      };
      preferences = lib.mkIf cfg.customPreferences {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "identity.sync.tokenserver.uri" = "https://firefox.kosslan.dev/1.0/sync/1.5"; # Custom Sync Server, see server modules
      };
    };
  };
}
