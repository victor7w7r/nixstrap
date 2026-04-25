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
  f2fs = import ./lib/f2fs.nix;
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

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-partlabel/esp";
      fsType = "vfat";
      options = [
        "lazytime"
        "noatime"
        "umask=0077"
        "dmask=0077"
        "codepage=437"
        "iocharset=ascii"
        "shortname=mixed"
        "errors=remount-ro"
        "nofail"
      ];
    };
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
      label = "nixos";
      device = "/dev/disk/by-partlabel/nixos";
    };
  };

  boot = {
    kernelPackages = kernel.packages;
    consoleLogLevel = 7;
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      systemd-boot.extraFiles.${config.hardware.deviceTree.name} =
        "${config.hardware.deviceTree.package}/${config.hardware.deviceTree.name}";
      efi.canTouchEfiVariables = false;
      systemd-boot.consoleMode = "0";
    };
    kernelParams = [
      "console=ttyMSM0,115200"
      "console=tty0"
      "dtb=/${config.hardware.deviceTree.name}"
    ];
    initrd = {
      extraUtilsCommands = ''
        copy_bin_and_libs ${(pkgs.callPackage ../custom/buffybox.nix { })}/bin/buffyboard
        cp -a ${pkgs.libinput.out}/share $out/
      '';
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

}
