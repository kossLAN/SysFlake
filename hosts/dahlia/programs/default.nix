{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nvim-pkg
  ];

  programs = {
    git.enable = true;
    common.enable = true;
  };
}
