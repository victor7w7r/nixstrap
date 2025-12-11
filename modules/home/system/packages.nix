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
      fclones-gui
      fortune
      inxi
      mommy
      rclone-browser
      warehouse
      #mission-center
      #https://github.com/trmckay/fzf-open
      #https://github.com/undergroundwires/privacy.sexy
    ]
  );

  programs = {
    bottom.enable = true;
    broot.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    nnn.enable = true;
    navi.enable = true;
    tealdeer.enable = true;
    fzf.enable = true;
    hwatch.enable = true;
    fd.enable = true;
    mc.enable = true;
    #lazydocker.enable = true;
    looking-glass-client.enable = true;
    lsd.enable = true;
    ripgrep-all.enable = true;
    rclone.enable = true;
    vifm.enable = true;
    xplr.enable = true;
  };
  services.kdeconnect.enable = true;
  services.pueue.enable = true;

}
