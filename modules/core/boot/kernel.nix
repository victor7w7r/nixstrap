{ pkgs, ... }:
let
  supportedFilesystems = [
    "btrfs"
    "ext4"
    "exfat"
    "f2fs"
    "ntfs"
    "vfat"
  ];
in
{
  boot = {
    consoleLogLevel = 4;
    modprobeConfig.enable = true;
    inherit supportedFilesystems;
    kernelPackages = pkgs.linuxPackages_cachyos;
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
      verbose = true;
      systemd = {
        enable = true;
        emergencyAccess = true;
        users.root.shell = "${pkgs.bashInteractive}/bin/bash";
        storePaths = [ "${pkgs.bashInteractive}/bin/bash" ];
        extraBin = {
          ip = "${pkgs.iproute2}/bin/ip";
          ping = "${pkgs.iputils}/bin/ping";
          cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
        };
      };
    };
    kernelModules = [
      "tcp_bbr"
      "veth"
      "xt_comment"
      "xt_CHECKSUM"
      "xt_MASQUERADE"
      "vhost_vsock"
      "iptable_mangle"
    ];
    extraModprobeConfig = ''
      blacklist iTCO_wdt
      blacklist joydev
      blacklist mousedev
      blacklist mac_hid
      blacklist intel_hid

      options kvm-amd nested=1
      options kvm-intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    kernel.sysctl = {
      "fs.file-max" = 9223372036854775807;
      "fs.aio-max-nr" = 19349474;
      "fs.aio-nr" = 0;
      "fs.epoll.max_user_watches" = 39688724;
      "fs.inotify.max_queued_events" = 1048576;
      "fs.inotify.max_user_instances" = 1048576;
      "fs.inotify.max_user_watches" = 1048576;
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.keys.maxkeys" = 2000;
      "kernel.keys.maxbytes" = 2000000;
      "kernel.nmi_watchdog" = 0;
      "kernel.printk" = "3 3 3 3";
      "kernel.split_lock_mitigate" = 0;
      "kernel.sysrq" = 1;
      "kernel.unprivileged_userns_clone" = 1;
      "net.core.bpf_jit_limit" = 1000000000;
      "net.core.default_qdisc" = "cake";
      "net.core.netdev_max_backlog" = 4096;
      "net.core.optmem_max" = 65536;
      "net.core.somaxconn" = 8192;
      "net.core.rmem_default" = 26214400;
      "net.core.rmem_max" = 26214400;
      "net.core.wmem_default" = 26214400;
      "net.core.wmem_max" = 26214400;
      "net.ipv4.neigh.default.gc_thresh3" = 8192;
      "net.ipv6.neigh.default.gc_thresh3" = 8192;
      "net.ipv4.ip_forward" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv6.icmp.echo_ignore_all" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.default.forwarding" = 1;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.udp_rmem_min" = 8192;
      "net.ipv4.udp_wmem_min" = 8192;
      "net.ipv4.tcp_max_syn_backlog" = 8192;
      "net.ipv4.tcp_max_tw_buckets" = 2000000;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_fin_timeout" = 10;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_keepalive_time" = 60;
      "net.ipv4.tcp_keepalive_intvl" = 10;
      "net.ipv4.tcp_keepalive_probes" = 6;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_sack" = 1;
      "vm.dirty_background_ratio" = 3;
      "vm.dirty_bytes" = 268435456;
      "vm.hugetlb_shm_group" = 0;
      "vm.dirty_expire_centisecs" = 3000;
      "vm.dirty_ratio" = 3;
      "vm.min_free_kbytes" = 59030;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.max_map_count" = 2147483642;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
      "vm.swappiness" = 60;
      "vm.watermark_scale_factor" = 125;
      "vm.watermark_boost_factor" = 0;
    };

    tmp.cleanOnBoot = true;
    tmp.useTmpfs = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 70;
  };

}
