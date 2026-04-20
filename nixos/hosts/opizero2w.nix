{
  config,
  host,
  pkgs,
  kernelData,
  ...
}:
let
  uboot = pkgs.buildUBoot {
    defconfig = "orangepi_zero2w_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${pkgs.armTrustedFirmwareAllwinnerH616}/bl31.bin";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
    nativeBuildInputs = with pkgs; [
      swig
      openssl
      python3
      python3Packages.setuptools
      pkg-config
      python3Packages.libfdt
      gnutls
      bison
      flex
      swig
      bc
      dtc
    ];
  };

  kernel = (pkgs.callPackage ../kernel/sunxi) { inherit kernelData; };
in
{

  imports = [
    (import ./lib/sdcard.nix {
      inherit config pkgs host;
      rootVolumeLabel = "OPIZERO2W";
      populateFirmwareCommands = ''
        mkdir -p firmware/boot
        ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
          -c ${config.system.build.toplevel} \
          -d firmware/boot
      '';
      postBuildCommands = "dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$img bs=1024 seek=8 conv=notrunc";
    })
  ];

  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot = {
    kernelParams = [
      "earlycon"
      "loglevel=7"
      "console=ttyS0,115200"
      "earlycon=uart,mmio32,0x05000000"
      "clk_ignore_unused"
    ];
    initrd = {
      kernelModules = [
        "sunxi-mmc"
        "sdhci_pci"
        "usb_storage"
        "uas"
        "uhci_hcd"
        "ehci_hcd"
        "xhci_pci"
        "mmc_block"
        "sdhci_acpi"
        "sdhci"
        "nvmem_sunxi_sid"
      ];
      supportedFilesystems = [ "f2fs" ];
    };
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    extraModprobeConfig = "options zram num_devices=1";
    kernelPackages = kernel.packages;
  };

  networking.wireless.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /lib/firmware - - - - /run/current-system/firmware"
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  hardware.deviceTree = {
    enable = true;
    #filter = "sun50i-h618-orangepi-zero2w.dtb";
    name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
  };
}
