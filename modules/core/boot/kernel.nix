{
  pkgs,
  ...
}:
let
  supportedFilesystems = [
    "btrfs"
    "ext4"
    "f2fs"
  ];
in
{
  boot = {
    consoleLogLevel = 4;
    modprobeConfig.enable = true;
    inherit supportedFilesystems;

    loader = {
      efi.efiSysMountPoint = "/boot/EFI";
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      systemd-boot.enable = false;
    };

    initrd = {
      checkJournalingFS = true;
      compressor = "xz";
      compressorArgs = [
        "--check=crc32"
        "--lzma2=dict=6MiB"
        "-T0"
      ];
      network.enable = true;
      inherit supportedFilesystems;
      services.lvm.enable = true;
      systemd = {
        enable = true;
        emergencyAccess = true;
        initrdBin = [
          pkgs.iproute2
          pkgs.bash
          pkgs.gnugrep
          pkgs.findutils
        ];
      };
    };

    extraModprobeConfig = ''
      blacklist iTCO_wdt
      blacklist joydev
      blacklist mousedev
      blacklist mac_hid
      blacklist intel_hid
    '';

    kernel.sysctl = {
      "vm.swappiness" = 60;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_bytes" = 268435456;
      "vm.page-cluster" = 0;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.max_map_count" = 2147483642;
      "kernel.nmi_watchdog" = 0;
      "kernel.split_lock_mitigate" = 0;
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.kptr_restrict" = 2;
      "net.core.netdev_max_backlog" = 4096;
      "fs.file-max" = 2097152;
    };

    tmp.cleanOnBoot = true;
    tmp.useTmpfs = true;
  };
  #binfmt.emulatedSystems = [ "aarch64-linux" ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 70;
  };

}
