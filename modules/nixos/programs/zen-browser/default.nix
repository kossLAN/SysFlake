# This is taken mostly from the firefox nixos module, just adapted for the changes in zen.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.programs.zen-browser;
  policyFormat = pkgs.formats.json {};

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
in {
  imports = [./config.nix];

  options.programs.zen-browser = {
    enable = mkEnableOption "Zen Browser";

    package = mkOption {
      default = inputs.zen-browser.packages.${pkgs.system}.default;
      type = lib.types.package;
    };

    policies = lib.mkOption {
      type = policyFormat.type;
      default = {};
      description = ''
        Group policies to install.

        See [Mozilla's documentation](https://mozilla.github.io/policy-templates/)
        for a list of available options.

        This can be used to install extensions declaratively! Check out the
        documentation of the `ExtensionSettings` policy for details.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [cfg.package];

      etc = let
        policiesJSON = policyFormat.generate "policies.json" {inherit (cfg) policies;};
      in
        lib.mkIf (cfg.policies != {}) {
          "zen/policies/policies.json".source = "${policiesJSON}";
        };
    };
  };
}
