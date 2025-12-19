{ pkgs, lib, ... }:
with lib;
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde # Portal
    ];
  };

  services = {
    libinput.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "intl-unicode";
      options = "caps:ctrl_modifier";
    };
    desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };

    flatpak = {
      enable = true;
      /*
        packages = [
          "io.github.DenysMb.Kontainer"
          "io.github.nyre221.kiview"
          "org.kde.kommit"
          "com.github.d4nj1.tlpui"
          "in.srev.guiscrcpy"
          "com.github.vikdevelop.photopea_app"
          "com.github.tchx84.Flatseal"
          "io.emeric.toolblex"
        ];
        update.auto = {
          enable = true;
          onCalendar = "weekly";
          };
      */
    };
  };
}
