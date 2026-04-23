{ pkgs, ... }:
let
  xiaomiVendor = "2717";
  oneplusVendor = "18d1";
in
{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="${xiaomiVendor}", MODE="[]", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="${xiaomiVendor}", ATTR{idProduct}=="ff40", SYMLINK+="android_adb"
    SUBSYSTEM=="usb", ATTR{idVendor}=="${xiaomiVendor}", ATTR{idProduct}=="ff40", SYMLINK+="android_fastboot"

    SUBSYSTEM=="usb", ATTR{idVendor}=="${oneplusVendor}", MODE="[]", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="${oneplusVendor}", ATTR{idProduct}=="d00d", SYMLINK+="android_adb"
    SUBSYSTEM=="usb", ATTR{idVendor}=="${oneplusVendor}", ATTR{idProduct}=="d00d", SYMLINK+="android_fastboot"
  '';

  environment.systemPackages = with pkgs; [
    adbfs-rootless
    adb-sync
    adbtuifm
    androguard
    android-file-transfer
    android-tools
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
