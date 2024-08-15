# Again this is mostly ripped from outfoxxed, cannot overstate how helpful this is
{
  config,
  pkgs,
  deployment,
}: let
  cfg = config.services.headscale;
  dataDir = "/var/lib/headscale";

  headscaleConfig = {
    server_url = "https://ts.${cfg.reverseProxy.domain}";
    listen_addr = "0.0.0.0:3442";
    metrics_listen_addr = "0.0.0.0:3443";

    grpc_listen_addr = "127.0.0.1:50443";
    grpc_allow_insecure = false;

    private_key_path = "${dataDir}/private.key";
    noise.private_key_path = "${dataDir}/noise_private.key";

    ip_prefixes = [
      "fd7a:115c:a1e0::/48"
      "100.64.0.0/10"
    ];

    derp = {
      server = {
        enabled = true;
        region_id = 900;
        region_code = "headscale";
        region_name = "Headscale Embedded DERP";
        stun_listen_addr = "0.0.0.0:8344";
      };

      urls = [];
      paths = [];

      auto_update_enabled = false;
      update_frequency = "24h";
    };

    disable_check_updates = true;
    ephemeral_node_inactivity_timeout = "30m";
    node_update_check_interval = "10s";
    db_type = "sqlite3";
    db_path = "${dataDir}/db.sqlite";
    acme_url = "";
    acme_email = "";

    tls_letsencrypt_hostname = "";
    tls_letsencrypt_cache_dir = "${dataDir}/cache";
    tls_letsencrypt_challenge_type = "HTTP-01";
    tls_letsencrypt_listen = ":http";
    tls_cert_path = "";
    tls_key_path = "";

    log = {
      format = "text";
      level = "info";
    };

    acl_policy_path = "";

    dns_config = {
      override_local_dns = true;
      base_domain = "ts.net";
      nameservers = ["1.1.1.1" "8.8.8.8"];

      domains = deployment.tailnetFqdnList;

      extra_records = builtins.map (fqdn: {
        name = fqdn;
        type = "A";
        value = "100.64.0.1"; # Again assuming this the correct IP
      }) (deployment.tailnetFqdnList);

      magic_dns = true;
    };

    unix_socket = "/var/run/headscale/headscale.sock";
    unix_socket_permission = "0770";

    logtail.enabled = false;
    randomize_client_port = false;
  };
in
  (pkgs.formats.yaml {}).generate "headscale.yaml" headscaleConfig
