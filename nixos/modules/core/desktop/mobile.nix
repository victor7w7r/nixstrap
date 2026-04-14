{ pkgs, ... }:
let
  ini = pkgs.formats.ini { };
in
{
  environment.etc."xdg/kdeglobals".source = ini.generate "kdeglobals" {
    KDE.LookAndFeelPackage = "org.kde.plasma.phone";
  };
  environment.etc."xdg/kwinrc".source = ini.generate "kwinrc" {
    Wayland."InputMethod[$e]" =
      "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
    Wayland.VirtualKeyboardEnabled = "true";
    "org.kde.kdecoration2".NoPlugin = "true";
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        settings.General.DisplayServer = "wayland";
      };
      sessionPackages = [ pkgs.kdePackages.plasma-mobile ];
      defaultSession = "plasma-mobile";
      autoLogin = {
        enable = true;
        user = "victor7w7wr";
      };
    };
  };
}
