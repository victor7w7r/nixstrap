{
  den.aspects.gui.fonts = {
    nixos = { isPersistent, pkgs, ... }: {
      environment.systemPackages =
        with pkgs;
        [
          corefonts
          dejavu_fonts
          font-awesome
          noto-fonts-color-emoji
          nerd-fonts.dejavu-sans-mono
          nerd-fonts.jetbrains-mono
          nerd-fonts.noto
          nerd-fonts.ubuntu
          nerd-fonts.symbols-only
          #openmoji-color
          open-sans
        ]
        ++ lib.optionals (!isPersistent) [
          hack-font
          liberation_ttf
          libertine
          libertinus
          noto-fonts-cjk-sans
          nerd-fonts.code-new-roman
          nerd-fonts.liberation
          nerd-fonts.roboto-mono
        ];

      fonts = {
        enableDefaultPackages = true;
        fontDir.enable = true;
        fontconfig = {
          enable = true;
          cache32Bit = true;
          useEmbeddedBitmaps = true;
          subpixel.rgba = "rgb";
          defaultFonts = {
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "UbuntuMono Nerd Font"
              "Noto Color Emoji"
            ];
            sansSerif = [
              "Ubuntu Nerd Font"
              "Noto Color Emoji"
            ];
            serif = [
              "Ubuntu Nerd Font"
              "Noto Color Emoji"
            ];
          };
        };
      };
    };

    provides.to-users.homePackages.fonts.fontconfig.defaultFonts.monospace = [
      "JetBrainsMono Nerd Font"
    ];
  };
}
