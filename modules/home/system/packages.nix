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
}
