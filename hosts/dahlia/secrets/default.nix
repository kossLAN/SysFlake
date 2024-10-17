{
  self,
  inputs,
  ...
}: let
  path = "${self.outPath}/secrets";
in {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    tailscale.file = "${path}/tailscale.age";
    cloudflare.file = "${path}/cloudflare.age";
  };
}
