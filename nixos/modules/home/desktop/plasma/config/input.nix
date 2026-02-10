{ ... }:
{
  programs.plasma = {
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
        options = [ "caps:ctrl_modifier" ];
      };

      mice = [
        {
          accelerationProfile = "none";
          name = "Telink Wireless Receiver Mouse";
        }
      ];
      touchpads = [
        {
          accelerationProfile = "none";
          enable = true;
          leftHanded = false;
          middleButtonEmulation = true;
          name = "Wacom Intuos5 touch S Finger";
          naturalScroll = true;
          pointerSpeed = 0;
          productId = "056a";
          rightClickMethod = "twoFingers";
          scrollMethod = "twoFingers";
          tapAndDrag = false;
          tapToClick = true;
          vendorId = "0026";
        }
      ];
    };
    configFile.kcminputrc = {
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."0" = "Disabled";
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."1" = "Disabled";
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."2" = "Disabled";
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."3" = "Disabled";
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."4" = "Disabled";
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."5" = "Disabled";
      "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."6" = "Disabled";
      "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/0"."0" = "Disabled";
      "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/1"."0" = "Disabled";
      "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/2"."0" = "Disabled";
      "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/3"."0" = "Disabled";
      "ButtonRebinds/TabletTool/Wacom Intuos5 touch S (WL) Pen"."0" = "Disabled";
      "ButtonRebinds/TabletTool/Wacom Intuos5 touch S (WL) Pen"."1" = "MouseButton,273";
      "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."0" = "Disabled";
      "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."1" = "MouseButton,273";
      "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."331" = "MouseButton,274";
      "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."332" = "MouseButton,273";
      "Libinput/1241/41119/E-Signal USB Gaming Mouse".PointerAccelerationProfile = 1;
      "Libinput/1386/38/Wacom Intuos5 touch S (WL) Pen".MapToWorkspace = true;
      "Libinput/1386/38/Wacom Intuos5 touch S Pen".MapToWorkspace = true;
    };
  };
}
