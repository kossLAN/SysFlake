{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.caddy;
in {
  options.services.caddy = {
    landingPage = mkEnableOption "Landing Page";
  };

  config = mkIf cfg.landingPage {
    services.caddy = {
      virtualHosts = {
        "kosslan.dev" = {
          extraConfig = ''
            header Content-Type text/html
            respond "
              <html>
                <head><title>Petrolea</title></head>
                <body>
                  <h3>Literally nothing to see here man.</h3>
                </body>
              </html>
            "
          '';
        };
      };
    };
  };
}
