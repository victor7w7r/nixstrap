{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      pkgtop
      cargo-binstall
      eget
      #https://github.com/sorairolake/hf
      # https://github.com/devmatteini/dra
      # https://github.com/nvbn/thefuck
      # https://github.com/GianlucaP106/mynav
      # https://github.com/codervijo/journalview
      # https://github.com/Code-Hex/Neo-cowsay
      sampler
      wtfutil
      cmd-wrapped
      fw
      feh
      catimg
      jp2a

      superfile
      termscp
      walk
      tuifimanager
      #https://github.com/mananapr/cfiles
      # https://codeberg.org/sylphenix/sff
      # https://github.com/nore-dev/fman
      mediainfo
      atool
      trash-cli
      resvg

      cheat
      progress
      pv
      # https://github.com/kattouf/ProgressLine
      watchexec
      tran
      diskonaut
      dust
      dua
      gdu

      # https://github.com/napisani/procmux
      # https://github.com/Miserlou/Loop
      scrcpy
      qtscrcpy
      spytrap-adb
      #https://github.com/JeffLIrion/adb_shell
      # https://github.com/AKotov-dev/adbmanager
      adbfs-rootless
      #https://github.com/Aldeshov/ADBFileExplorer
      adb-sync
      # https://codeberg.org/izzy/Adebar
      androguard
      android-file-transfer
      #https://github.com/ASHWIN990/app-manager
      go-mtpfs
      simple-mtpfs
      adbtuifm
      gnirehtet
      #https://github.com/yan12125/logcat-color3
      # https://github.com/mrrfv/open-android-backup
      payload-dumper-go
      #https://github.com/erev0s/apkInspector
      universal-android-debloater
      #https://github.com/jb2170/better-adb-sync
      #https://github.com/vaibhavpandeyvpz/apkstudio
      #https://github.com/lavafroth/droidrunco
      # https://github.com/Bluemangoo/scrcpy-wrapper
      # https://github.com/opeolluwa/beats
      # https://github.com/liriliri/aya
    ]
  );

  #w3m
  programs.broot.enable = true;
  programs.nnn.enable = true;
  programs.topgrade.enable = true;
  programs.xplr.enable = true;
  programs.mc.enable = true;
  programs.vifm.enable = true;
  programs.yazi.enable = true;

  programs.tealdeer.enable = true;
  programs.navi.enable = true;

  services.croc.enable = true;

  programs.hwatch.enable = true;
  services.pueue.enable = true;
}
