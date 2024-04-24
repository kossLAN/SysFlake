{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.forgejo;
in {
  options.services.forgejo = {
    customConf = lib.mkEnableOption "Forgjo custom configuration";
  };

  config = lib.mkIf cfg.customConf {
    services = {
      forgejo = {
        # TODO: Configure this instead of relying on the wizard.
        # useWizard = true;
        settings = {
          server = {
            HTTP_PORT = 4000;
            HTTP_ADDR = "127.0.0.1";
            DOMAIN = "git.kosland.dev";
          };

          service.DISABLE_REGISTRATION = true;
          database.SQLITE_JOURNAL_MODE = "WAL";

          cache = {
            ADAPTER = "twoqueue";
            HOST = ''{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}'';
          };

          DEFAULT.APP_NAME = "Forgejo";
          repository.DEFAULT_BRANCH = "master";
          ui.DEFAULT_THEME = "arc-green";

          "ui.meta" = {
            AUTHOR = "Forgejo";
            DESCRIPTION = "kossLAN's self-hosted git instance";
          };

          metrics.ENABLED = true;
        };
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "git.kosslan.dev" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:4000/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_ssl_server_name on;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };
        };
      };
    };
  };
}
