{
  lib,
  config,
  modulesPath,
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
  };
  kernel = (pkgs.callPackage ../kernel/sunxi) { inherit kernelData; };
in
{

  imports = [
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];
  sdImage = {
    firmwareSize = 32;
    populateFirmwareCommands = "";

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
        -c ${config.system.build.toplevel} \
        -d ./files/boot
    '';

    postBuildCommands = ''
      dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$img \
        bs=1024 seek=8 \
        conv=notrunc
    '';
  };

  /*
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
  */

  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  nix.settings.extra-sandbox-paths = [ "/nix/var/cache/ccache-kernel" ];
  programs.ccache = {
    enable = true;
    cacheDir = "/nix/var/cache/ccache-kernel";
  };

  boot = {
    kernelParams = lib.mkDefault [
      "console=ttyS0,115200"
      "console=tty1"
      "earlycon=uart,mmio32,0x05000000"
    ];
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    extraModprobeConfig = "options zram num_devices=1";
    kernelPackages = kernel.packages;
    kernelModules = [
      "sprdwl_ng"
      "sprdbt_tty"
      "sun4i_drm"
      "sun8i_mixer"
      "hdmi"
      "dw_hdmi"
      "display_connector"
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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  hardware = {
    enableAllHardware = true;
    firmware = [ (pkgs.callPackage ./custom/sunxi.nix { }) ];
    deviceTree = {
      enable = true;
      filter = "sun50i-h618-orangepi-zero2w.dtb";
      name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
    };
  };
}
