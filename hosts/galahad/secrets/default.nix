{
  self,
  inputs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    wg0server.file = ../../../secrets/wg0server.age;
  };
}
