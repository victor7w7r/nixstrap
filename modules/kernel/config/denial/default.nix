{ kernel, lib, ... }:
{
  kernel.config.denial.all =
    {
      config,
      isArm ? false,
    }:
    with kernel.config.denial;
    with kernel.lib;
    [
      comm.all
      common.all
      hardware.all
      misc
      net.all
      net-hardware.all
      serial.all
      sound.all
      storage.all
      vendor.all
      (dynamic-denial {
        inherit config;
        attr = "EEPROM";
        excludes = [ "93CX6" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "NLS_MAC";
      })
      (dynamic-denial {
        inherit config;
        attr = "NLS_CODEPAGE";
        excludes = [ "437" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "TCP_CONG";
        excludes = [
          "ADVANCED"
          "CUBIC"
          "BBR"
        ];
      })
      (dynamic-denial {
        inherit config;
        attr = "USB_STORAGE";
      })
    ]
    ++ (lib.optionals isArm [
      (dynamic-denial {
        inherit config;
        attr = "RMI4";
      })
    ]);
}
