{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.services.caddy;
in {
  config = mkIf cfg.enable {
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
