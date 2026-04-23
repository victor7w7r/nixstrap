{
  config,
  lib,
  pkgs,
  kernelData,
  inputs,
  device ? "fajita",
  ...
}:
{
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT}=="1", SUBSYSTEMS=="input", ATTRS{name}=="pmi8998_haptics", TAG+="uaccess", ENV{FEEDBACKD_TYPE}="vibra"
    SUBSYSTEM=="misc", KERNEL=="fastrpc-*", ENV{ACCEL_MOUNT_MATRIX}+="-1, 0, 0; 0, -1, 0; 0, 0, -1"
  '';
  environment.systemPackages = [ (pkgs.callPackage ../custom/sdm845-alsa.nix { }) ];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable32Bit = lib.mkForce false;
  mobile.quirks.qualcomm.sdm845-modem.enable = true;
  mobile.quirks.audio.alsa-ucm-meld = true;
  nixpkgs.config.allowUnfreePredicate =
     pkg:
     builtins.elem (lib.getName pkg) [
       "firmware-oneplus-sdm845"
       "firmware-oneplus-sdm845-xz"
     ];
  hardware.firmware = lib.mkAfter [ (pkgs.callPackage ../custom/oneplus.nix { }) ];

  systemd.services.ModemManager.serviceConfig.ExecStart = [
    ""
    "${pkgs.modemmanager}/bin/ModemManager --test-quick-suspend-resume"
  ];

  mobile.usb = {
    mode = "gadgetfs";
    idVendor = lib.mkDefault "18D1";
    idProduct = lib.mkDefault "D001";
    gadgetfs.functions = {
      adb = "ffs.adb";
      mass_storage = "mass_storage.0";
      rndis = "rndis.usb0";
    };
  };

  mobile = {
    hardware = {
      soc = "qualcomm-sdm845";
      ram = 8192;
      screen.width = 1080;
    };

    boot.stage-1 = {
      compression = "xz";
      kernel.package = (pkgs.callPackage ../../kernel/sdm845 { inherit kernelData; }).build;
      firmware = [
        (pkgs.runCommand "initrd-firmware" { } ''
          cp -vrf ${config.mobile.device.firmware} $out
          chmod -R +w $out
          find $out/lib/firmware/qcom/sdm845 -name "modem.mbn" -delete -print
          cp -vf ${pkgs.linux-firmware}/lib/firmware/qcom/{a630_sqe.fw,a630_gmu.bin} $out/lib/firmware/qcom
        '')
      ];
    };

    device = {
      identity.manufacturer = "OnePlus";
      firmware = pkgs.callPackage "${inputs.mobile-nixos}/devices/oneplus-enchilada/firmware" { };
    };

    system = {
      type = "android";
      android = {
        ab_partitions = lib.mkDefault true;
        bootimg.flash = {
          offset_base = "0x00000000";
          offset_kernel = "0x00008000";
          offset_ramdisk = "0x01000000";
          offset_second = "0x00000000";
          offset_tags = "0x00000100";
          pagesize = "4096";
        };
        appendDTB = lib.mkDefault [
          "${
            pkgs.callPackage ../../kernel/sdm845/dtb.nix { inherit kernelData device; }
          }/sdm845-oneplus-${device}.dtb"
        ];
      };
    };
  };

}
