# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    xdg-desktop-portal-kde = prev.xdg-desktop-portal-kde.overrideAttrs (old: {
      postFixup = ''
        wrapProgram $out/libexec/xdg-desktop-portal-kde \
          --set QT_QPA_PLATFORM wayland
      '';
    });
  };

  # Allows me to use stable/unstable packages where I need them.
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
