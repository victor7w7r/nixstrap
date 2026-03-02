{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = import ./lib/boot.nix { };
  f2fs = import ./lib/f2fs.nix;
  shared = (import ./lib/shared.nix) { };
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/shared";

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

    "/nix" = f2fs {
      label = "system";
      device = "/dev/vg0/syscrypt";
    };
  };

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="iio", ATTR{name}=="mxc4005", ENV{ID_INPUT_ACCELEROMETER}="1", ENV{ACCEL_MOUNT_MATRIX}="0,-1,0;-1,0,0;0,0,1"
    '';
    extraHwdb = ''
      evdev:name:Goodix Capacitive TouchScreen:dmi:*
       EVDEV_ABS_00=::1280
       EVDEV_ABS_01=::720
       EVDEV_ABS_35=::1280
       EVDEV_ABS_36=::720
       LIBINPUT_CALIBRATION_MATRIX=-1 0 1 0 -1 1
    '';
  };

  swapDevices = [ { device = "/dev/vg0/swapcrypt"; } ];
  boot = {
    kernelParams = [
      "intel_iommu=on"
      "fbcon=rotate:3"
      "mem_sleep_default=deep"
      "acpi_backlight=vendor"
      "i915.enable_dpcd_backlight=1"
    ]
    ++ intelParams
    ++ params { };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;
    initrd = {
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-emmc-systempv";
        preLVM = true;
      };
      availableKernelModules = [ "i915" ];
      kernelModules = [ "dm-snapshot" ];
    };
  };
}
