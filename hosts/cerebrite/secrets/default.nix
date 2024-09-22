{
  config,
  self,
  inputs,
  ...
}: let
  path = "${self.outPath}/secrets";
in {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    wg0server.file = "${path}/wg0server.age";
    wg1server.file = "${path}/wg1server.age";
    av0client1.file = "${path}/av0client1.age";
    av0preshared.file = "${path}/av0preshared.age";

    prometheus.file = "${path}/prometheus.age";
    firefox.file = "${path}/firefox.age";
    lidarr.file = "${path}/lidarr.age";

    # deluge = {
    #   file = "${path}/deluge.age";
    #   owner = config.services.deluge.user;
    # };

    syncthing = {
      file = "${path}/syncthing.age";
      owner = config.services.syncthing.user;
    };
  };
}
