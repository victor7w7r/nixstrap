{
  den.aspects.plasma.maliit = {
    nixos =
      { pkgs, ... }:
      {
        programs.dconf.enable = true;

        environment.systemPackages = [
          pkgs.dconf-editor
        ];
      };

    provides.to-users.homeManager =
      { lib, pkgs, ... }:
      {
        programs.plasma.configFile.kwinrc.Wayland = {
          InputMethod = "${pkgs.maliit-keyboard}/share/applications/com.github.maliit.keyboard.desktop";
          VirtualKeyboardEnabled = true;
        };
        dconf.settings = {
          "org/maliit/keyboard/maliit" = {
            enabled-languages = lib.hm.gvariant.mkArray lib.hm.gvariant.type.string [
              "en"
              "es"
              "emoji"
            ];
            theme = "BreezeDark";
          };
        };
      };
  };
}
