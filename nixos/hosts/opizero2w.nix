{
  lib,
  config,
  pkgs,
  kernelData,
  host,
  ...
}:
let
  uboot = pkgs.buildUBoot {
    defconfig = "orangepi_zero2w_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${pkgs.armTrustedFirmwareAllwinnerH616}/bl31.bin";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };
  kernel = (pkgs.callPackage ../kernel/sunxi.nix) { inherit kernelData; };
in
{
  nix.settings.extra-sandbox-paths = [ "/nix/var/cache/ccache-kernel" ];
  programs.ccache = {
    enable = true;
    cacheDir = "/nix/var/cache/ccache-kernel";
  };
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
      postBuildCommands = ''
        dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$img bs=1024 seek=8 conv=notrunc
      '';
    })
  ];

  boot = {
    kernelParams = lib.mkDefault [
      "console=ttyS0,115200n8"
      "console=tty0"
    ];
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    extraModprobeConfig = "options zram num_devices=1";
    kernelPackages = lib.mkForce kernel.packages;
    kernelPatches = kernel.patches;
    kernelModules = [
      "sprdwl_ng"
      "sprdbt_tty"
      "sunxi_addr"
      "zram"
      "zstd"
      "zstd_compress"
      "crypto_zstd"
    ];
  };

  networking.wireless.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /lib/firmware - - - - /run/current-system/firmware"
  ];
  hardware = {
    enableAllHardware = true;
    firmware = [ (pkgs.callPackage ./custom/sunxi.nix { }) ];
    deviceTree = {
      enable = true;
      name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
    };
  };
}
