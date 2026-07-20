{ lib, ... }: {
  den.aspects.plasma.input.provides.to-users.homeManager.programs.plasma = {
    input = {
      keyboard = {
        layouts = [
          {
            layout = "us";
            displayName = "us";
            variant = "intl-unicode";
          }
          {
            layout = "latam";
            displayName = "es";
          }
        ];
        options = [ ];
      };
      mice = [
        {
          accelerationProfile = "none";
          name = "Telink Wireless Receiver Mouse";
          vendorId = "248a";
          acceleration = -0.4;
          productId = "8367";
        }
        {
          accelerationProfile = "none";
          name = "MOSART Semi. 2.4G Keyboard Mouse";
          vendorId = "062a";
          acceleration = -0.1;
          productId = "4101";
        }
        {
          accelerationProfile = "none";
          name = "E-Signal USB Gaming Mouse";
          vendorId = "04d9";
          acceleration = -0.5;
          productId = "a09f";
        }
        {
          accelerationProfile = "none";
          name = "XING WEI 2.4G USB USB Composite Device Mouse";
          vendorId = "040a";
          acceleration = 0.2;
          productId = "2814";
        }
      ];
    };
    configFile = {
      kxkbrc.Layout = lib.mkForce {
        Use = true;
        DisplayNames = ",es";
        VariantList = "intl-unicode,";
        Options = "caps:ctrl_modifier";
        LayoutList = "us,latam";
        ResetOldOptions = true;
      };
      kcminputrc = {
        "Libinput/1241/41119/E-Signal USB Gaming Mouse".PointerAccelerationProfile = 1;
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad" = {
          "0" = "Disabled";
          "1" = "Disabled";
          "2" = "Disabled";
          "3" = "Disabled";
          "4" = "Disabled";
          "5" = "Disabled";
          "6" = "Disabled";
        };
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/0"."0" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/1"."0" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/2"."0" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/3"."0" = "Disabled";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S (WL) Pen" = {
          "0" = "Disabled";
          "1" = "MouseButton,273";
        };
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen" = {
          "0" = "Disabled";
          "1" = "MouseButton,273";
          "331" = "MouseButton,274";
          "332" = "MouseButton,273";
        };
        "Libinput/1386/38/Wacom Intuos5 touch S (WL) Pen".MapToWorkspace = true;
        "Libinput/1386/38/Wacom Intuos5 touch S Pen".MapToWorkspace = true;
        "Libinput/1386/38/Wacom Intuos5 touch S Finger" = {
          Enabled = true;
          ClickMethod = 2;
          LeftHanded = false;
          MiddleButtonEmulation = true;
          NaturalScroll = true;
          PointerAcceleration = 0;
          PointerAccelerationProfile = 1;
          ScrollMethod = 1;
          TapAndDrag = false;
          TapToClick = true;
        };
      };
    };
  };
}
