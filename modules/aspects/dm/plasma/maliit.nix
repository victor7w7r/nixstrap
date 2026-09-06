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
      { pkgs, ... }:
      {
        programs.plasma.configFile.kwinrc.Wayland = {
          InputMethod = "${pkgs.maliit-keyboard}/share/applications/com.github.maliit.keyboard.desktop";
          VirtualKeyboardEnabled = true;
        };

        dconf.settings = {
          "org/maliit/keyboard/maliit" = {
            enabled-languages = [
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
