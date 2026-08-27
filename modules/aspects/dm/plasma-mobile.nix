{
  den.aspects.plasma-mobile = {
    nixos =
      { pkgs, ... }:
      {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.settings.General.DisplayServer = "wayland";
        services.xserver.enable = true;
        services.displayManager.defaultSession = "plasma-mobile";
        services.displayManager.sessionPackages = [pkgs.kdePackages.plasma-mobile];
        environment.etc."xdg/kdeglobals".source = ini.generate "kdeglobals" {
          KDE.LookAndFeelPackage = "org.kde.plasma.phone";
        };
        environment.etc."xdg/kwinrc".source = ini.generate "kwinrc" {
          Wayland."InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
          Wayland.VirtualKeyboardEnabled = "true";
          "org.kde.kdecoration2".NoPlugin = "true";
        };
        environment.systemPackages = with pkgs.kdePackages; [
          plasma-mobile
          plasma-nano
          plasma-dialer
          spacebar
          pkgs.maliit-framework
          pkgs.maliit-keyboard
        ];
      };
  };
}
