{ inputs, ... }:
{
  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  den.aspects.gui.flatpak =
    { user, ... }:
    {
      nixos.environment.persistence."/nix/persist".users."${user.name}".directories = [
        ".config/flatpak"
      ];

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
          services.flatpak = {
            enable = false;
            update = {
              auto = {
                enable = true;
                onCalendar = "weekly";
              };
              onActivation = true;
            };
            packages = [
              "io.github.DenysMb.Kontainer"
              "io.github.nyre221.kiview"
              "org.kde.kommit"
              "com.github.d4nj1.tlpui"
              "in.srev.guiscrcpy"
              "com.github.vikdevelop.photopea_app"
              "com.github.tchx84.Flatseal"
              "io.emeric.toolblex"
              "KDiskFree"
              "OptiImage"
            ];
          };
          home.packages = with pkgs; [
            flatpak
            warehouse
          ];
        };
    };
}
