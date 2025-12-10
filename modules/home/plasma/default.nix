{ ... }:
{
  imports = [
    (import ./packages.nix)
    (import ./config.nix)
    #(import ./custom.nix)
  ];

  services = {
    kdeconnect.enable = true;

    /*
      fprintd.enable = true;
        xserver.xkb = {
          layout = "us";
          variant = "workman";
          options = "caps:ctrl_modifier";
        };
        displayManager = {
          plasma6 = {
            enable = true;
            enableQt5Integration.enable = true;
          };
          sddm = {
            wayland.enable = true;
          };
          };

          flatpak = {
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
          }; TO CORE
    */

  };
}
