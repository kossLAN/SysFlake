{
  self,
  inputs,
  ...
}: let
  path = "${self.outPath}/secrets";
in {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    wg0client1.file = "${path}/wg0client1.age";
    wg0preshared.file = "${path}/wg0preshared.age";
  };
}
