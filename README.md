<h1 align="center">
  SysFlake
  <br>
  <img src="resources/nixos.svg" width="200px" height="200px"/>
  <br>
  My trash system system flake that you SHOULD NOT use!
</h1>

## Features
  - **Singular home-manager home**: because I have systems where I don't use NixOS and having a unified home is easier for me to manage
  - **Management for my dotfiles in one place where I can easily switch between them**
  - **Host support for NixOS & Nix-Darwin**
  - Don't know what else to put here, things are pretty bog standard

## Why you should not copy me
  - This is highly personal and not well documented because of that
  - I make mistakes/and or I'm lazy with this repo because I am the only customer
  - It's valuable to learn nix for yourself to effectively use it for yourself
  - If you do end up copying me I apologize...

## Credits (Cool people I copied/talked nix with)
  [NotAShelf](https://github.com/NotAShelf), [Misterio77](https://github.com/Misterio77), and probably others...

## Nice to know's 
  - Build a system(alternatively use nh):
    
    ```nixos-rebuild --flake .#<system> switch|boot```
  - Rebuild home-manager(alternatively use nh):

    ```home-manager --flake .#<user>@<system> switch```
  - Build iso image of a system configuration:
    
    ```nixos-rebuild build --flake .#nixosConfigurations.<system>.config.system.build.isoImage;```

## Notes
  - I'm not a very aesthetic person when it comes to my ReadMe's so this is the best you get 8)
  - I have yet to overhaul my system configuration for galahad as it is the longest standing component in my system
