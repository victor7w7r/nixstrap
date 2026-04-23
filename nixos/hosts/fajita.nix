{
  inputs,
  kernelData,
  config,
  lib,
  pkgs,
  ...
}:
let
  kernel = (pkgs.callPackage ../kernel/sdm845) { inherit kernelData; };
in
{
  imports = [
    (import ./lib/qcom-845.nix {
      inherit
        inputs
        kernelData
        config
        lib
        pkgs
        ;
    })
  ];

  system.build.uboot = kernel.uboot;

  boot = {
    kernelPackages = kernel.packages;
    consoleLogLevel = 7;
    kernelParams = [
      "console=ttyMSM0,115200"
      "console=tty0"
      "dtb=/${config.hardware.deviceTree.name}"
    ];
    initrd = {
       includeDefaultModules = false;
       kernelModules = [
         "i2c_qcom_geni"
         "rmi_core"
         "rmi_i2c"
         "qcom_spmi_haptics"
         "dm_mod"
         "zfs"
         "spl"
       ];
       availableKernelModules = [
         "configfs"
         "libcomposite"
         "g_ffs"

         "i2c_qcom_geni"
         "rmi_core"
         "rmi_i2c"

         "ext2"
         "ext4"
         "mmc_block"
         "sd_mod"
         "uhci_hcd"
         "ehci_hcd"
         "ehci_pci"
         "ohci_hcd"
         "ohci_pci"
         "xhci_hcd"
         "xhci_pci"
         "usbhid"
         "hid_generic"
         "hid_lenovo"
         "hid_apple"
         "hid_roccat"
         "hid_logitech_hidpp"
         "hid_logitech_dj"
         "hid_microsoft"
         "hid_cherry"
         "hid_corsair"
         "zfs"
         "spl"
         "dm_mod"
       ];
     };
    loader = {
       grub.enable = false;
       systemd-boot.enable = true;
       systemd-boot.extraFiles.${config.hardware.deviceTree.name} =
         "${config.hardware.deviceTree.package}/${config.hardware.deviceTree.name}";
       systemd-boot.consoleMode = "0";
       efi.canTouchEfiVariables = false;
     };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 60;
    priority = 100;
  };
  hardware.deviceTree = {
    enable = true;
    name = "qcom/sdm845-oneplus-fajita.dtb";
  };

  mobile = {
    system.android.device_name = "OnePlus6T";
    generatedFilesystems.rootfs = lib.mkDefault {
      filesystem = lib.mkForce "btrfs";
      extraPadding = lib.mkForce (pkgs.image-builder.helpers.size.MiB 128);
    };
    device = {
      name = "oneplus-fajita";
      supportLevel = "best-effort";
      identity.name = "OnePlus 6T";
    };
    hardware.screen.height = 2340;
  };
}
