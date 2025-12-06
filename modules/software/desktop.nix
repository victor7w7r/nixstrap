{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      vlc
      vlc-bittorrent
      #vlc-pause-click-plugin vlc-plugin-pipewire vlc-plugin vlc-plugins-all vlc-plugin-ytdl-git
      morphosis
      #https://github.com/codewithmoss/ytdl
      tenacity
      kid3-kde
      #https://github.com/Shabinder/SpotiFlyer
      # https://davidepucci.it/doc/spotitube/#installation
      franz
      media-downloader
      # easyeffects-bundy01-presets easyeffects-jtrv-presets-git
      # https://github.com/paulpacifico/shutter-encoder
      lsp-plugins
      calf
      zam-plugins
      mda-lv2
      sonic-visualiser
      inkscape-with-extensions
      pinta
      rnote
      lunacy
      legcord
      #https://github.com/Tyrrrz/DiscordChatExporter
      discord-screenaudio
      mtr-gui
      music-discord-rpc
      #https://aur.archlinux.org/packages/jdownloader2-jre
      # https://github.com/abdularis/LAN-Share
      lan-mouse
      prismlauncher
      #https://github.com/almahdi/nix-thorium
      mailspring
      #zen-browser-sponsorblock zen-browser-ublock-origin zen-browser-dark-reader zen-browser-violentmonkey
      rclone-browser

      cool-retro-term
      windterm
      bruno
      jetbrains.datagrip
      notepadqq
      git-credential-manager

      bleachbit
      czkawka-full

      sticky-notes

      natron
      davinci-resolve
      #https://github.com/tkmxqrdxddd/davinci-video-converter
      # https://tahoma2d.org/
      lightworks
      #https://github.com/undergroundwires/privacy.sexy

      axel
      #https://github.com/debasish-patra-1987/linuxthemestore
      inxi
      woeusb-ng
      clamtk
      stacer
      ventoy-full-qt
      kopia-ui
      cpu-x
      ddrescueview
      warehouse
      distroshelf
      snapper-gui
      btrfs-assistant
      #https://aur.archlinux.org/packages/repair-usb-disc-gtk4
      qdiskinfo
      usbimager
      testdisk-qt
    ]
  );

  programs.pywal.enable = true;
  services.rustdesk.enable = true;
  services.lact.enable = true;
  programs.kitty.enable = true;
  programs.onlyoffice.enable = true;
  programs.coolercontrol.enable = true;
  programs.corectrl.enable = true;
  programs.zed-editor.enable = true;
}
