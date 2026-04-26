{
  config,
  host,
  pkgs,
  kernelData,
  ...
}:
let
  uboot = import ./custom/sunxi-uboot.nix { inherit pkgs; };
  f2fs = import ./lib/f2fs.nix;
  kernel = (pkgs.callPackage ../kernel/sunxi) { inherit kernelData; };
in
{
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

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
      #"earlycon"
      "console=ttyS0,115200n8"
      "console=tty0"
    ];
    initrd = {
      systemd.contents."/share/terminfo".source = "${pkgs.ncurses}/share/terminfo";
      kernelModules = [
        "sunxi-mmc"
        "usb_storage"
        "uas"
        "uhci_hcd"
        "ehci_hcd"
        "xhci_pci"
        "sdhci_acpi"
        "sdhci"
        "g_ether"
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

  hardware = {
    firmware = [ (pkgs.callPackage ./custom/uwe5622.nix { }) ];
    deviceTree = {
      enable = true;
      name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
    };
  };
}
