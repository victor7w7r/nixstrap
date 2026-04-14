{
  lib,
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

    nativeBuildInputs = with pkgs; [
      dtc
      armTrustedFirmwareTools
      bison
      flex
      which
      swig
      openssl

      (python3.withPackages (p: [
        p.setuptools
        p.libfdt
        p.pyelftools
      ]))
    ];

  };
  kernel = (pkgs.callPackage ../kernel/sunxi) { inherit kernelData; };
in
{
  sdImage = {
    compressImage = true;
    postBuildCommands = ''
      dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$img bs=1024 seek=8 conv=notrunc
    '';
  };

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

  fileSystems."/persist".neededForBoot = true;

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "relatime"
        "mode=755"
        "size=1G"
      ];
    };

    disk = {
      sd = {
        type = "disk";
        device = "/dev/mmcblk0";
        content = {
          type = "gpt";
          partitions = {
            firmware = {
              size = "1024M";
              label = "FIRMWARE";
              type = "0700";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                ];
              };
            };

            boot = {
              size = "512M";
              label = "BOOT";
              type = "0700";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                ];
              };
            };

            nix = {
              label = "NIX";
              size = "100%";
              content = {
                type = "filesystem";
                mountpoint = "/nix";
                format = "f2fs";
                mountOptions = [
                  "lazytime"
                  "noatime"
                  "compress_chksum"
                  "compress_algorithm=zstd:3"
                  "age_extent_cache"
                  "compress_extension=so"
                  "inline_xattr"
                  "inline_data"
                  "inline_dentry"
                  "errors=remount-ro"
                  "compress_extension=bin"
                  "atgc"
                  "flush_merge"
                  "discard"
                  "checkpoint_merge"
                  "gc_merge"
                ];
              };
            };
          };
        };
      };
    };
  };

  boot = {
    kernelParams = [
      "earlycon"
      "console=ttyS0,115200n8"
    ];
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    extraModprobeConfig = "options zram num_devices=1";
    #kernelPackages = kernel.packages;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_6_18;
    initrd.availableKernelModules = [ "sunxi-mmc" ];
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
    name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
  };
}
