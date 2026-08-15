{
  den.aspects.android = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          adbfs-rootless
          adb-sync
          androguard
          android-file-transfer
          android-tools
          gnirehtet
          go-mtpfs
          qtscrcpy
          payload-dumper-go
          spytrap-adb
          scrcpy
          universal-android-debloater
        ];
      };

    nixos =
      {
        pkgs,
        self',
        isX86,
        ...
      }:
      {
        services.udev.extraRules =
          {
            xiaomi = "2717";
            oneplus = "18d1";
          }
          |> (vendors: ''
            SUBSYSTEM=="usb", ATTR{idVendor}=="${vendors.xiaomi}", ATTR{idProduct}=="ff40", SYMLINK+="android_adb"
            SUBSYSTEM=="usb", ATTR{idVendor}=="${vendors.xiaomi}", ATTR{idProduct}=="ff40", SYMLINK+="android_fastboot"
            SUBSYSTEM=="usb", ATTR{idVendor}=="${vendors.oneplus}", ATTR{idProduct}=="d00d", SYMLINK+="android_adb"
            SUBSYSTEM=="usb", ATTR{idVendor}=="${vendors.oneplus}", ATTR{idProduct}=="d00d", SYMLINK+="android_fastboot"
          '');

        environment.systemPackages =
          with pkgs;
          with self'.packages;
          [
            adb-shell
            adbtuifm
            adebar
            apkinspector
            app-manager
            better-adb-sync
            logcat-color3
            scrcpy-wrapper
            simple-mtpfs
            zilch
          ]
          ++ (lib.optionals isX86 [
            aya
          ]);
      };
  };
}
