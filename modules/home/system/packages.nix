{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      #clamtk
      bleachbit
      clolcat
      cpu-x
      czkawka-full
      distroshelf
      fclones-bin
      fortune
      inxi
      mommy
      rclone-browser
      stacer
      warehouse
      #mission-center
      #https://github.com/trmckay/fzf-open
      #https://github.com/undergroundwires/privacy.sexy
    ]
  );

  programs = {
    coolercontrol.enable = true;
    corectrl.enable = true;
    fzf.enable = true;
    eza.enable = true;
    fd.enable = true;
    lsd.enable = true;
    ripgrep-all.enable = true;
    rclone.enable = true;
  };

  services.lact.enable = true;
  services.rustdesk.enable = true;
}
