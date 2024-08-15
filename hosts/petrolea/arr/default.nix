{...}: let
  group = "storage";
in {
  imports = [./deluge.nix];

  users = {
    groups.storage = {
      name = "storage";
      members = [
        "deluge"
        "lidarr"
        "sonarr"
        "radarr"
      ];
      gid = 8000;
    };
  };

  virtualisation = {
    flaresolverr = {
      enable = true;
    };
  };

  services = {
    sonarr = {
      enable = true;
      group = group;
      reverseProxy = {
        enable = true;
        tailnet = true;
        domain = "ts.net";
      };
    };

    radarr = {
      enable = true;
      group = group;
      reverseProxy = {
        enable = true;
        tailnet = true;
        domain = "ts.net";
      };
    };

    lidarr = {
      enable = true;
      group = group;
      reverseProxy = {
        enable = true;
        tailnet = true;
        domain = "ts.net";
      };
    };

    prowlarr = {
      enable = true;
      reverseProxy = {
        enable = true;
        tailnet = true;
        domain = "ts.net";
      };
    };

    unpackerr = {
      enable = true;
      user = "root";
      group = "root";

      # For more information on this see module description.
      settings = {
        debug = false;
        quiet = false;
        error_stderr = false;
        activity = false;
        log_queues = "1m";
        log_files = 10;
        log_file_mb = 10;
        interval = "2m";
        start_delay = "1m";
        retry_delay = "5m";
        max_retries = 3;
        parallel = 1;
        file_mode = "0644";
        dir_mode = "0755";

        # Yes these are the very real API keys, but no you can't do anything with them
        # you can try, but these sites are all internal :P. Also since the ARR Suite has
        # no way of setting a specific API key this is not reproducible & thus is impure but
        # it is what it is
        lidarr = [
          {
            url = "http://127.0.0.1:8686";
            api_key = "e4ac32eb9ca44b51a9b39fc986f29215";
            paths = ["/srv/torrents"];
            protocols = "torrent";
            timeout = "10s";
            delete_delay = "5m";
            delete_orig = false;
            syncthing = false;
          }
        ];

        radarr = [
          {
            url = "http://127.0.0.1:7878";
            api_key = "ac46fdffb6d640649085ca7f3f617288";
            paths = ["/srv/torrents"];
            protocols = "torrent";
            timeout = "10s";
            delete_delay = "5m";
            delete_orig = false;
            syncthing = false;
          }
        ];

        sonarr = [
          {
            url = "http://127.0.0.1:8989";
            api_key = "b8a70d84fa5a4606a23859e9ee70a0ba";
            paths = ["/srv/torrents"];
            protocols = "torrent";
            timeout = "10s";
            delete_delay = "5m";
            delete_orig = false;
            syncthing = false;
          }
        ];
      };
    };

    jellyfin = {
      enable = true;
      reverseProxy = {
        enable = true;
        domain = "kosslan.dev";
      };
    };

    jellyseerr = {
      enable = true;
      reverseProxy = {
        enable = true;
      };
    };
  };
}
