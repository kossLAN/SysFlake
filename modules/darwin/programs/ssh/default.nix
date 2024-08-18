{
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.ssh;
in {
  options.programs.ssh = {
    importKeys = mkEnableOption "Import key files";
    importConfig = mkEnableOption "Import config";
  };

  config = {
    home-manager.users.${config.users.defaultUser} = {
      home.file = {
        ".ssh/config".text = lib.mkIf cfg.importConfig ''
          Host cerebrite
            HostName petrolea.koss.ts.net
            User koss
            Port 1000
        '';

        # Just do it this way cause the ssh module for darwin isn't great.
        ".ssh/id_rsa.pub".text = lib.mkIf (cfg.importKeys) ''
          ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpkeLOreGeqUDLcrlYgzyeSSZmBvJLY+dWOeORIpGQQVRvlko8NRcVKS/fa5EHBd9HG9gRs96FK5WF9JJCGsY4ovL++WZwlsQN3xfc0xq2Sn8TQhgDgiBFCR05JDMi1+f6v9WpaiLiQnOKiTmSGYhzvayIr/XrpcAaXo0mLDEnqZbSzqTcAcqZMcPZixmkgFJA+kUq6d1Z5XMPRRTPJNmLGY0jNbVlUiI9pWsIlGqZFcMLssNWnIZkl8SCV/lN+uyFy2G1o1LlMQ6UFziqP3Zm28gq6alt7ivFJ8A8hUffiZWeQ4uURV8TKhQ43FGSUspma7DpG5zGdionkN521rQJajdnWJLO25dXRkDdXWmkwpFuKRep0m0xv0VSxXAPYs5IrFuDuylbfo6W0N5dx2sPgBK8cQ2uj5AvVCM6g8cgWh+pxzG/WV/2XpwrT7jD8vyRUL+U6FpiMQIsepJ/WQIhA7HkQnex2QHGAsu7hP5Wr5Bs33m8JYT5XCT0KsXkzQE=
        '';
      };
    };
  };
}
