{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      adbfs-rootless
      adb-sync
      adbtuifm
      androguard
      android-file-transfer
      gnirehtet
      qtscrcpy
      payload-dumper-go
      spytrap-adb
      scrcpy
      universal-android-debloater
      #https://github.com/JeffLIrion/adb_shell
      #https://github.com/AKotov-dev/adbmanager
      #https://github.com/Aldeshov/ADBFileExplorer
      #https://codeberg.org/izzy/Adebar
      #https://github.com/ASHWIN990/app-manager
      #https://github.com/yan12125/logcat-color3
      #https://github.com/mrrfv/open-android-backup
      #https://github.com/erev0s/apkInspector
      #https://github.com/jb2170/better-adb-sync
      #https://github.com/vaibhavpandeyvpz/apkstudio
      #https://github.com/lavafroth/droidrunco
      #https://github.com/Bluemangoo/scrcpy-wrapper
      #https://github.com/liriliri/aya
    ];
}
