{ pkgs
, ...
}:
let
  hyprConfig = pkgs.writeText "greetd-hyprland-config" ''
    misc {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    }
    exec-once = ${pkgs.greetd.gtkgreet}/bin/gtkgreet -s ${./style.css} -c Hyprland; hyprctl dispatch exit
  '';
in
{
  # I use hyprland for launching the login-manager, however I also have it installed
  # via home-manager for regular use, so this is a weird situation of which I don't
  # know what the proper solution is...
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprConfig}";
      };
    };
  };
}
