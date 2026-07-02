{
  den.aspects.audio.packages = {
    nixos =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
          asak
          alsa-plugins
          alsa-utils
          alsa-firmware
          alsa-ucm-conf
          self'.packages.audio-share
          self'.packages.cliwrap
          self'.packages.gspot
          self'.packages.helvum
          kew
          musikcube
          self'.packages.lyricstify
          playerctl
          pavucontrol
          pwvucontrol
          psst
          sof-firmware
          spotdl
          sptlrx
          youtube-tui
          ytfzf
          ytmdl
          #linuxwave
          #spotify-adblock-git
          #spotify-adkiller-dns-block-git
          #https://github.com/carlocastoldi/blockify
          #https://github.com/trizen/clyrics
          #https://github.com/SathyaBhat/spotify-dl
          #https://github.com/foresterre/imagineer
        ];
      };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          #zam-plugins
          calf
          deepfilternet
          lsp-plugins
          libebur128
          zita-convolver
          mda_lv2
          speexdsp
          soundtouch
          rnnoise
        ];

        programs = {
          cava.enable = true;
          ncspot.enable = true;
        };
      };
  };
}
