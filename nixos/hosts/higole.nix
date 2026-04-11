{
  host,
  inputs,
  pkgs,
  kernelData,
  ...
}:
let
  params = import ./lib/kernel-params.nix;
  boot = import ./lib/boot.nix {
    emergencyDisk = "emmc";
    efiDisk = "emmc";
  };
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
  kernelBuild = (pkgs.callPackage ../kernel) {
    inherit
      helpers
      host
      kernelData
      inputs
      ;
  };
  f2fs = import ./lib/f2fs.nix;
  shared = (import ./lib/shared.nix) { sharedDisk = "emmc"; };
in
{
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

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
      device = "/dev/vg0/system";
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
       ID_INPUT=1
       ID_INPUT_TOUCHSCREEN=1
       ID_INPUT_KEYBOARD=0
       LIBINPUT_CALIBRATION_MATRIX=-1 0 1 0 -1 1
    '';
  };

  swapDevices = [ { device = "/dev/vg0/swapcrypt"; } ];

  powerManagement.cpuFreqGovernor = "conservative";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 60;
    priority = 100;
  };

  boot = {
    resumeDevice = "/dev/vg0/swapcrypt";
    kernelParams = [ "resume=/dev/vg0/swapcrypt" ] ++ params { };
    kernelPackages = helpers.kernelModuleLLVMOverride (kernelBuild.packages);
    #pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;
    blacklistedKernelModules = [ "pac1934" ];
    extraModprobeConfig = ''
      options goodix_ts reset_speed=100
      options goodix interrupt_duration=1
      options i2c_designware_core bus_speed=100
    '';
    initrd = {
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-emmc-systempv";
        crypttabExtraOpts = [ "tpm2-device=auto" ];
        preLVM = true;
      };
      availableKernelModules = [
        "i915"
        "intel_lpss_pci"
        "i2c_designware_pci"
        "i2c_designware_platform"
        "goodix_ts"
        "sdhci_pci"
      ];
      kernelModules = [
        "autofs"
        "tpm_crb"
        "tpm_tis"
        "sdhci_pci"
        "goodix_ts"
        "mxc4005"
        "sdhci_acpi"
        "intel_lpss_pci"
        "mmc_block"
        "dm-snapshot"
      ];
    };
  };
}
