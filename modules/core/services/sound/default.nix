{
  lib,
  config,
  ...
}: let
  cfg = config.services.sound;
in {
  # This is also going to be the same across my linux installs so best to abstract.
  options.services.sound = {
    enable = lib.mkEnableOption "sound";
  };

  config = lib.mkIf cfg.enable {
    services = {
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };

    security = {
      rtkit.enable = true;
    };

    # TODO: setup a global variable of sorts to manager user, or find
    # a better solution.
    users.users.${config.defaultUser}.extraGroups = [
      "pipewire"
    ];
  };
}
