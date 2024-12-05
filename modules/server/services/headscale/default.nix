# This module breaks way to much, and I'm over it.
{
  config,
  lib,
  pkgs,
  headscale-custom,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.headscale-custom;
in {
  options.services.headscale-custom = {
    enable = mkEnableOption "Enable headscale service";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.headscale;
      description = "The headscale package to use";
    };

    user = mkOption {
      type = lib.types.str;
      default = "headscale";
      description = "The user to run headscale as";
    };

    group = mkOption {
      type = lib.types.str;
      default = "headscale";
      description = "The group to run headscale as";
    };

    serverUrl = mkOption {
      type = lib.types.str;
      default = "https://kosslan.me";
      description = "The server URL for headscale";
    };

    baseDomain = mkOption {
      type = lib.types.str;
      default = "ts.kosslan.me";
      description = "The base domain for headscale";
    };

    tailnetDomain = mkOption {
      type = lib.types.str;
      default = "kosslan.me";
    };

    tailnetRecords = mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "The subdomain name";
          };

          value = lib.mkOption {
            type = lib.types.str;
            default = "100.64.0.1";
            description = "The value to associate with the subdomain";
          };
        };
      });
      default = [];
    };
  };

  config = mkIf cfg.enable {
    _module.args.headscale-custom = {
      # Adds a subdomain to tailscale dns records
      tailnetFqdnList =
        builtins.map
        (subdomain: {
          name = "${subdomain.name}.${cfg.tailnetDomain}";
          value = subdomain.value;
        })
        cfg.tailnetRecords;
    };

    environment = {
      systemPackages = [cfg.package];

      # NixOS Module is shit, gg go next
      # This was a outfoxxed idea, I just stole it
      etc."headscale/config.yaml".source =
        mkIf cfg.enable
        (lib.mkForce (import ./config.nix {
          inherit config pkgs headscale-custom;
        }));
    };

    users = {
      groups.headscale = lib.mkIf (cfg.group == "headscale") {};
      users.headscale = lib.mkIf (cfg.user == "headscale") {
        description = "headscale user";
        home = "/var/lib/headscale";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    systemd.services.headscale = {
      description = "headscale coordination server for Tailscale";
      wants = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      script = ''
        exec ${lib.getExe cfg.package} serve
      '';

      serviceConfig = let
        capabilityBoundingSet = ["CAP_CHOWN"];
      in {
        Restart = "always";
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Hardening options
        RuntimeDirectory = "headscale";
        # Allow headscale group access so users can be added and use the CLI.
        RuntimeDirectoryMode = "0750";

        StateDirectory = "headscale";
        StateDirectoryMode = "0750";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RemoveIPC = true;
        UMask = "0077";

        CapabilityBoundingSet = capabilityBoundingSet;
        AmbientCapabilities = capabilityBoundingSet;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallFilter = ["@system-service" "~@privileged" "@chown"];
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
      };
    };
  };
}
