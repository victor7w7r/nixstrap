{ kernel, lib, ... }:
{
  kernel.config.denial.dynamic =
    with kernel.lib;
    {
      config,
      isArm ? false,
    }:
    [
      (dynamic-denial {
        inherit config;
        attr = "BATTERY";
      })
      (dynamic-denial {
        inherit config;
        attr = "CHARGER";
      })
      (dynamic-denial {
        inherit config;
        attr = "COMMON_CLK";
      })
      (dynamic-denial {
        inherit config;
        attr = "DELL";
      })
      (dynamic-denial {
        inherit config;
        attr = "EEPROM";
        excludes = [ "93CX6" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "GAMEPORT";
      })
      (dynamic-denial {
        inherit config;
        attr = "JOYSTICK";
      })
      (dynamic-denial {
        inherit config;
        attr = "MOUSE";
      })
      (dynamic-denial {
        inherit config;
        attr = "NLS_MAC";
      })
      (dynamic-denial {
        inherit config;
        attr = "NLS_ISO8859";
        excludes = [ "1" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "PATA";
      })
      (dynamic-denial {
        inherit config;
        attr = "SERIO";
      })
      (dynamic-denial {
        inherit config;
        attr = "TOUCHSCREEN";
      })
      (dynamic-denial {
        inherit config;
        attr = "USB_STORAGE";
      })
      (dynamic-denial {
        inherit config;
        attr = "BACKLIGHT";
        excludes = [ "CLASS_DEVICE" "APPLE" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "KEYBOARD";
        excludes = [ "ATKBD" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "NLS_CODEPAGE";
        excludes = [ "437" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "RTC_DRV";
        excludes = [ "CMOS" ];
      })
      (dynamic-denial {
        inherit config;
        attr = "EXTCON";
        excludes = [
          "GPIO"
          "USB_GPIO"
        ];
      })
      (dynamic-denial {
        inherit config;
        attr = "HID";
        excludes = [
          "SUPPORT"
          "BATTERY_STRENGTH"
          "GENERIC"
          "HAPTIC"
          "ASUS"
          "WACOM"
          "PID"
          "I2C_HID"
          "MULTITOUCH"
        ];
      })
      (dynamic-denial {
        inherit config;
        attr = "LEDS";
        excludes = [
          "CLASS"
          "TRIGGERS"
          "TRIGGER_DISK"
          "TRIGGER_CPU"
          "TRIGGER_PATTERN"
        ];
      })
      (dynamic-denial {
        inherit config;
        attr = "NET_SCH";
        excludes = [
          "FQ_CODEL"
          "FQ"
          "INGRESS"
          "DEFAULT"
          "HTB"
          "FIFO"
        ];
      })
      (dynamic-denial {
        inherit config;
        attr = "REGULATOR";
        excludes = [
          "FIXED_VOLTAGE"
          "NETLINK_EVENTS"
        ];
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
        attr = "TYPEC";
        excludes = [
          "UCSI"
          "DP_ALTMODE"
          "TBT_ALTMODE"
        ];
      })
      (dynamic-denial {
        inherit config;
        attr = "USB_SERIAL";
        excludes = [
          "GENERIC"
          "CP210X"
          "CYPRESS_M8"
          "EMPEG"
          "FTDI_SIO"
        ];
      })
    ]
    ++ lib.optionals isArm [
      (dynamic-denial {
        inherit config;
        attr = "RMI4";
      })
    ];
}
