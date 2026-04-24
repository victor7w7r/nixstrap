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
  f2fs = import ./lib/f2fs.nix;
  kernel = (pkgs.callPackage ../kernel/sunxi) { inherit kernelData; };
in
{
  imports = [
    (import ./soc {
      inherit config pkgs host;
      postBuildCommands = "dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$bootImg bs=1024 seek=8 conv=notrunc";
      populateFirmwareCommands = ''
        mkdir -p firmware/boot
        ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
          -c ${config.system.build.toplevel} -d firmware/boot
      '';
    })
  ];

  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "nofail"
        "noauto"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/store";
      neededForBoot = true;
      fsType = "ext4";
      options = [
        "noatime"
        "nodiscard"
        "lazytime"
        "commit=60"
        "data=ordered"
        "barrier=0"
      ];
    };
    "/nix/persist" = f2fs {
      label = "persist";
      device = "/dev/disk/by-label/persist";
      depends = [ "/nix" ];
    };
  };

  boot = {
    kernelParams = [
      "earlycon"
      "loglevel=7"
      "console=ttyS0,115200"
      "earlycon=uart,mmio32,0x05000000"
      "clk_ignore_unused"
      "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
    ];
    initrd = {
      systemd.contents = {
        "/share/terminfo".source = "${pkgs.ncurses}/share/terminfo";
      };
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
    filter = "sun50i-h618-orangepi-zero2w.dtb";
    name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
  };
}
