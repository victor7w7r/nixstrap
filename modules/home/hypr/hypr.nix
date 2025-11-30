{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    dmenu-rs
    hyprland-qtutils
    hyprlock
    hyprpicker
    hyprfreeze
    hyprmon
    hyprnome
    hyprutils
    hyprviz
    grimblast
    pyprland.packages."x86_64-linux".pyprland
    rofi-bluetooth
    rofi-calc
    rofi-emoji
    rofi-power-menu
    rofimoji
    slurp
    swaybg
    swaylock-effects
    swaylock-fancy
    waybar-lyric
    wl-clip-persist
    wf-recorder
    glib
    #hypr hypr-input-switcher-bin hypr-zoom hyprdim-full-git hyprdvd
    #hyprfloat hyprmixer figlet-fonts dunst-timer rofi-connman rofi-greenclip
    #rofi-process-killer eleviewr rofi-tmux rofi-todo rofi-tools-bin autoricer
    #rustrland spofi-git rofi-wifi-menu rofi-themes-collection waybar-media-git
    #rofi-file-browser-extended-patched waybar-cava waybar-update waybar-dunst
    #zig-waybar-contrib swaylock-blur-fast-git swaylock-corrupter swaylock-fprintd
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  services = {
    cliphist.enable = true;
    dunst.enable = true;
    hypridle.enable = true;
    hyprpolkitagent.enable = true;
    hyprpaper.enable = true;
    hyprshell.enable = true;
    hyprshot.enable = true;
    hyprsunset.enable = true;
    network-manager-applet.enable = true;
    wob.enable = true;
  };

  programs = {
    wlogout.enable = true;
    uwsm.enable = true;
    bemenu.enable = true;
    iio-hyprland.enable = true;
    tofi.enable = true;
    waybar.enable = true;
  };

  wayland.windowManager.hyprland = {
    systemd.enable = true;
    enable = true;
    xwayland.enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
    ];
  };
}
