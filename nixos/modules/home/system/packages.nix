{
  system,
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
      chromium
      #(inputs.thorium.thorium-avx .overrideAttrs (oldAttrs: { }))
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
