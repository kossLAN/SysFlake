{ 
  pkgs,
  ...
}: {
  imports = [
    #catppuccin
    ./pure-black
  ];

  home.packages = with pkgs; [
    nerdfonts
  ];
}
