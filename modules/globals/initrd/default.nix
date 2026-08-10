{
  den.default.nixos = { lib, ... }: {
    boot = {
      supportedFilesystems = [
        "btrfs"
        "ext4"
        "exfat"
        "f2fs"
        "ntfs"
        "vfat"
      ];
      modprobeConfig.enable = true;
      kernelParams = lib.mkAfter [
        "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
        "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
        "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
        "split_lock_detect=off"
        "nowatchdog"
        "nmi_watchdog=0"
        "zram.num_devices=2"
        "kvm.ignore_msrs=1"
        "kvm.report_ignored_msrs=0"
      ];
      tmp = {
        cleanOnBoot = true;
        useTmpfs = true;
      };
      extraModprobeConfig = ''
        blacklist iTCO_wdt
        blacklist joydev
        blacklist mousedev
        blacklist mac_hid
        blacklist intel_hid
      '';
      initrd = {
        checkJournalingFS = true;
        services.lvm.enable = true;
        compressorArgs = [
          "-19"
          "--ultra"
          "-T0"
          "--check"
        ];
        network.enable = true;
        verbose = true;
      };
    };
  };
}
