{ kernel, lib, ... }: {
  kernel.config.input = with lib.kernel; {
    apply = with kernel.config.input; include // denied;

    /*
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
    */

    include = {
      INPUT_EVDEV = yes;
      KEYBOARD_ATKBD = yes;
      NLS_CODEPAGE_437 = lib.mkForce yes;
      NLS_ISO8859_1 = lib.mkForce yes;
    };

    denied = lib.mkMerge [
      #CODIFICATION
      {
        NLS_ISO8859_2 = no;
        NLS_ISO8859_3 = no;
        NLS_ISO8859_4 = no;
        NLS_ISO8859_5 = no;
        NLS_ISO8859_6 = no;
        NLS_ISO8859_8 = no;
        NLS_ISO8859_7 = no;
        NLS_ISO8859_9 = no;
        NLS_ISO8859_13 = no;
        NLS_ISO8859_14 = no;
        NLS_ISO8859_15 = no;
        NLS_KOI8_R = no;
        NLS_KOI8_U = no;
      }
      #INPUT
      {
        INPUT_JOYDEV = no;
        INPUT_MOUSEDEV = no;
        INTEL_ISH_HID = no;
        INTEL_THC_HID = no;
        INPUT_AD714X = no;
        INPUT_ADXL34X = no;
        INPUT_APANEL = no;
        INPUT_ARIZONA_HAPTICS = no;
        INPUT_ATI_REMOTE2 = no;
        INPUT_ATLAS_BTNS = no;
        INPUT_AW86927 = no;
        INPUT_BMA150 = no;
        INPUT_CM109 = no;
        INPUT_CMA3000 = no;
        INPUT_DA7280_HAPTICS = no;
        INPUT_DRV260X_HAPTICS = no;
        INPUT_DRV2665_HAPTICS = no;
        INPUT_DRV2667_HAPTICS = no;
        INPUT_E3X0_BUTTON = no;
        INPUT_GPIO_BEEPER = no;
        INPUT_GPIO_DECODER = no;
        INPUT_GPIO_ROTARY_ENCODER = no;
        INPUT_GPIO_VIBRA = no;
        INPUT_IBM_PANEL = no;
        INPUT_IDEAPAD_SLIDEBAR = no;
        INPUT_IMS_PCU = no;
        INPUT_IQS269A = no;
        INPUT_IQS626A = no;
        INPUT_IQS7222 = no;
        INPUT_JOYSTICK = lib.mkForce no;
        INPUT_KEYSPAN_REMOTE = no;
        INPUT_KXTJ9 = no;
        INPUT_MMA8450 = no;
        INPUT_PCF8574 = no;
        INPUT_PCSPKR = no;
        INPUT_POWERMATE = no;
        INPUT_PWM_BEEPER = no;
        INPUT_PWM_VIBRA = no;
        INPUT_REGULATOR_HAPTIC = no;
        INPUT_YEALINK = no;
      }
      #KEYBOARD
      {
        KEYBOARD_ADC = no;
        KEYBOARD_ADP5588 = no;
        KEYBOARD_APPLESPI = lib.mkForce no;
        KEYBOARD_CHARLIEPLEX = no;
        KEYBOARD_QT1050 = no;
        KEYBOARD_QT1070 = no;
        KEYBOARD_QT2160 = no;
        KEYBOARD_DLINK_DIR685 = no;
        KEYBOARD_LKKBD = no;
        KEYBOARD_GPIO = no;
        KEYBOARD_GPIO_POLLED = no;
        KEYBOARD_TCA8418 = no;
        KEYBOARD_MATRIX = no;
        KEYBOARD_LM8323 = no;
        KEYBOARD_LM8333 = no;
        KEYBOARD_MAX7359 = no;
        KEYBOARD_MPR121 = no;
        KEYBOARD_NEWTON = no;
        KEYBOARD_OPENCORES = no;
        KEYBOARD_PINEPHONE = no;
        KEYBOARD_SAMSUNG = no;
        KEYBOARD_STOWAWAY = no;
        KEYBOARD_SUNKBD = no;
        KEYBOARD_TM2_TOUCHKEY = no;
        KEYBOARD_XTKBD = no;
        KEYBOARD_CYPRESS_SF = no;
      }
      #POINTERS
      {
        MOUSE_PS2 = no;
        MOUSE_APPLETOUCH = no;
        MOUSE_BCM5974 = no;
        MOUSE_CYAPA = no;
        MOUSE_ELAN_I2C = no;
        MOUSE_VSXXXAA = no;
        MOUSE_GPIO = no;
        MOUSE_SERIAL = no;
        MOUSE_SYNAPTICS_I2C = no;
        MOUSE_SYNAPTICS_USB = no;
        TABLET_SERIAL_WACOM4 = no;
        TABLET_USB_ACECAD = no;
        TABLET_USB_AIPTEK = no;
        TABLET_USB_HANWANG = no;
        TABLET_USB_KBTAB = no;
        TABLET_USB_PEGASUS = no;
      }
      #HID
      {
        HID_A4TECH = no;
        HID_ACCUTOUCH = no;
        HID_ACRUX = no;
        HID_ALPS = no;
        HID_APPLE = no;
        HID_APPLEIR = no;
        HID_APPLETB_BL = no;
        HID_APPLETB_KBD = no;
        HID_AUREAL = no;
        HID_BELKIN = no;
        HID_BETOP_FF = no;
        HID_BIGBEN_FF = no;
        HID_CHERRY = no;
        HID_CHICONY = no;
        HID_CMEDIA = no;
        HID_CORSAIR = no;
        HID_COUGAR = no;
        HID_CP2112 = no;
        HID_CREATIVE_SB0540 = no;
        HID_CYPRESS = no;
        HID_DRAGONRISE = no;
        HID_ELAN = no;
        HID_ELECOM = no;
        HID_ELO = no;
        HID_EMS_FF = no;
        HID_EVISION = no;
        HID_EZKEY = no;
        HID_FT260 = no;
        HID_HUAWEI = no;
        HID_GEMBIRD = no;
        HID_GFRM = no;
        HID_GLORIOUS = no;
        HID_GOODIX_SPI = no;
        HID_GOOGLE_STADIA_FF = no;
        HID_GREENASIA = no;
        HID_GT683R = no;
        HID_GYRATION = no;
        HID_HOLTEK = no;
        HID_ICADE = no;
        HID_ITE = no;
        HID_JABRA = no;
        HID_KENSINGTON = no;
        HID_KEYTOUCH = no;
        HID_KYE = no;
        HID_KYSONA = no;
        HID_LCPOWER = no;
        HID_LED = no;
        HID_LENOVO = no;
        HID_LENOVO_GO = no;
        HID_LENOVO_GO_S = no;
        HID_LETSKETCH = no;
        HID_LOGITECH = no;
        HID_MACALLY = no;
        HID_MAGICMOUSE = no;
        HID_MALTRON = no;
        HID_MAYFLASH = no;
        HID_MCP2200 = no;
        HID_MCP2221 = no;
        HID_MEGAWORLD_FF = no;
        HID_MICROSOFT = no;
        HID_MONTEREY = no;
        HID_NINTENDO = no;
        HID_NTI = no;
        HID_NTRIG = no;
        HID_ORTEK = no;
        HID_PANTHERLORD = no;
        HID_PENMOUNT = no;
        HID_PETALYNX = no;
        HID_PICOLCD = no;
        HID_PLANTRONICS = no;
        HID_PLAYSTATION = no;
        HID_PRIMAX = no;
        HID_PRODIKEYS = no;
        HID_PXRC = no;
        HID_RAPOO = no;
        HID_RAZER = no;
        HID_REDRAGON = no;
        HID_RETRODE = no;
        HID_RMI = no;
        HID_ROCCAT = no;
        HID_SAITEK = no;
        HID_SAMSUNG = no;
        HID_SEMITEK = no;
        HID_SENSOR_HUB = no;
        HID_SIGMAMICRO = no;
        HID_SMARTJOYPLUS = no;
        HID_SONY = no;
        HID_SPEEDLINK = no;
        HID_STEAM = no;
        HID_STEELSERIES = no;
        HID_SUNPLUS = no;
        HID_THINGM = no;
        HID_THRUSTMASTER = no;
        HID_TIVO = no;
        HID_TOPRE = no;
        HID_TOPSEED = no;
        HID_TWINHAN = no;
        HID_U2FZERO = no;
        HID_UCLOGIC = no;
        HID_UDRAW_PS3 = no;
        HID_VIEWSONIC = no;
        HID_VIVALDI = no;
        HID_VRC2 = no;
        HID_WALTOP = no;
        HID_WIIMOTE = no;
        HID_WINWING = no;
        HID_XIAOMI = no;
        HID_XINMO = no;
        HID_ZEROPLUS = no;
        HID_ZYDACRON = no;
      }
    ];
  };
}
