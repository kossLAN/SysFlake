let
  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMw1hLInzGOHV+b0TNmQbl0HHR4cabnZjPdbXcqkSNk";
  cerebrite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvg58shvVbIlXIpUV9chtflXmbq51uCMTpdYoKbcftD";
  petrolea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIp7VvyyhyF22O6BQNNgrUfxq/+6kLoQwpPHjqAgxCEL";
  galahad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZglP92ZxsqI4wRzGR/A3kEQIQPB94pwysihwo9bT+E";

  systems = [backup cerebrite petrolea galahad];
in {
  # Wireguard Keys
  "wg0server.age".publicKeys = systems;
  "wg1server.age".publicKeys = systems;
  "wg0client1.age".publicKeys = systems;
  "wg0client2.age".publicKeys = systems;
  "wg1client1.age".publicKeys = systems;

  "av0client1.age".publicKeys = systems;
  "av0preshared.age".publicKeys = systems;

  # ARR Suite
  "lidarr.age".publicKeys = systems;
  #"sonarr.age".publicKeys = systems;
  #"radarr.age".publicKeys = systems;

  # Nextcloud Password
  "nextcloud.age".publicKeys = systems;

  # Deluge WebUI Password
  "deluge.age".publicKeys = systems;

  # Prometheus
  "prometheus.age".publicKeys = systems;

  # Firefox Sync Server
  "firefox.age".publicKeys = systems;

  # Syncthing WebUI Password
  "syncthing.age".publicKeys = systems;
}
