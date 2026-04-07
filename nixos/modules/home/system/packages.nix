{
  system,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      #clamtk
      bleachbit
      home-manager
      caffeine-ng
      clolcat
      czkawka-full
      inputs.thorium
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
    ++ (if system != "aarch64-linux" then [ cpu-x ] else [ ])
  );
}
