{ config, lib, ... }:
{
  boot.kernelParams = lib.mkAfter [
    "lsm=landlock,yama,integrity,apparmor,bpf"
    "rw"
    "add_efi_memmap"
    "root=${config.setupDisks.mockDisk}"
    "rootfstype=ext4"
    "rootflags=noatime,lazytime,nobarrier,nodiscard,commit=120"
    "loglevel=3"
    "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
    "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
    "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    "nowatchdog"
    "mitigations=off"
    "rcutree.enable_rcu_lazy=1"
    "rcupdate.rcu_expedited=1"
    "libahci.ignore_sss=1"
    "nospectre_v1"
    "nospectre_v2"
    "spec_store_bypass_disable=off"
    "page_alloc.shuffle=1"
    "tsc=reliable"
    "srbds=off"
    "systemd.debug-shell=1"
    "systemd.unit=rescue.target"
    #"kvmfr.static_size_mb=128"
    #systemd.unit=multi-user.target single
  ];

  boot.kernel.sysctl = {
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
}
