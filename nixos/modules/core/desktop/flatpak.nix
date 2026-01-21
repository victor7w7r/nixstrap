{ ... }:
{
  #https://github.com/MykolaSuprun/nixos-flakes-config/blob/c0b9e3356c8675cb50885a279b0978b99abdb705/nixos/modules/flatpak.nix
  services.flatpak = {
    enable = false;
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
