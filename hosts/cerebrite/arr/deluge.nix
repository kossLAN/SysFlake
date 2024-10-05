# Aids deluge setup, in container because I route the traffic via a VPN
# Not in a module cause the module just becomes really aids
{
  lib,
  config,
  deployment,
  ...
}: {
  deployment = {
    containers.deluge.owner = "deluge";
  };

  networking = {
    firewall.allowedTCPPorts = [8112];
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "wlp5s0";
    };
  };

  users = {
    users = {
      deluge = {
        group = "storage";
        uid = config.ids.uids.deluge;
        description = "Deluge Daemon user";
      };
    };
  };

  systemd.tmpfiles.rules = ["d /mnt/ssd1/torrents 1775 deluge storage"];

  containers.deluge = {
    autoStart = true;
    privateNetwork = true;
    enableTun = true;
    hostAddress = "192.168.100.10";
    localAddress = deployment.containerHostIp "deluge";
    forwardPorts = [
      {
        containerPort = 8112;
        hostPort = 8112;
        protocol = "tcp";
      }
    ];

    config = {
      networking = {
        useHostResolvConf = lib.mkForce false;

        firewall = {
          enable = true;
          allowedTCPPorts = [8112 58846 43567 36060];
        };

        wg-quick.interfaces.av0 = {
          autostart = true;
          privateKeyFile = config.age.secrets.av0client1.path;
          mtu = 1320;
          dns = ["10.128.0.1"];

          address = [
            "10.137.214.184/32"
            "fd7d:76ee:e68f:a993:a9d8:93a3:2832:7941/128"
          ];

          peers = [
            {
              publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
              presharedKeyFile = config.age.secrets.av0preshared.path;
              endpoint = "146.70.115.141:1637";
              allowedIPs = ["0.0.0.0/0"];
              persistentKeepalive = 15;
            }
          ];
        };
      };

      users.groups.deluge = {
        gid = lib.mkForce (deployment.serviceGID "storage");
      };

      services = {
        resolved.enable = true;

        deluge = {
          enable = true;
          declarative = true;
          authFile = config.age.secrets.deluge.path;

          web = {
            enable = true;
            port = 8112;
          };

          config = {
            download_location = "/srv/torrents/";
            max_upload_speed = "6500";
            share_ratio_limit = "2.0";
            seed_time_limit = "25000";
            allow_remote = true;
            listen_interface = "10.137.214.184";
            daemon_port = 58846;
            listen_ports = [43567 36060];
            enabled_plugins = ["Label"];
          };
        };
      };

      system.stateVersion = "24.05";
    };

    bindMounts = {
      "${config.age.secrets.av0client1.path}" = {isReadOnly = true;};
      "${config.age.secrets.av0preshared.path}" = {isReadOnly = true;};
      "${config.age.secrets.deluge.path}" = {isReadOnly = true;};
      "/srv/torrents" = {
        isReadOnly = false;
        hostPath = "/mnt/ssd1/torrents";
      };
    };
  };
}
