{ ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "io.github.DenysMb.Kontainer"
      "io.github.nyre221.kiview"
      "org.kde.kommit"
      "com.github.d4nj1.tlpui"
      "in.srev.guiscrcpy"
      "com.github.vikdevelop.photopea_app"
      "com.github.tchx84.Flatseal"
      "io.emeric.toolblex"
      /*
        KDiskFree
        OptiImage
      */
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
