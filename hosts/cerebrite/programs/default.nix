{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nvim-pkg
  ];

  programs = {
    common.enable = true;
    git.enable = true;
  };
}
