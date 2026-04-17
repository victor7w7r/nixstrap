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
    version = "2024.04";
    src = pkgs.fetchurl {
      url = "https://ftp.denx.de/pub/u-boot/u-boot-2024.04.tar.bz2";
      hash = "sha256-GKhT/jn6160DqQzC1Cda6u1tppc13vrDSSuAUIhD3Uo=";
    };
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

  programs.ccache = {
    enable = true;
    cacheDir = "/nix/var/cache/ccache-kernel";
  };

  boot = {
    kernelParams = [
      "earlycon"
      "loglevel=7"
      "console=ttyS0,115200"
      "earlycon=uart,mmio32,0x05000000"
      "clk_ignore_unused"
    ];
    initrd.availableKernelModules = [
      "sunxi-mmc"
      "mmc_block"
      "nvmem_sunxi_sid"
    ];
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
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
