{
  inputs,
  lib,
  kernel,
  kernel-versions,
  ...
}:
{
  flake-file.inputs.bunker-patches = {
    url = "github:amaanq/bunker-patches";
    flake = false;
  };

  kernel.patches.bunker = {
    common = { }: [
      "bunker/0006-enable-kstack_erase-by-default"
      "bunker/0008-disable-proc_kcore-by-default"
      "clear/0001-net-dst-reduce-false-sharing-in-dst_entry"
      "clear/0009-mm-compaction-increase-proactive-compaction-check-in"
      "grapheneos/0001-disable-ldisc_autoload-by-default"
      "grapheneos/0004-disable-memory_hotplug-by-default"
      "xanmod/0003-block-set-rq_affinity-to-force-complete-I-O-on-same-"
      "xanmod/0004-block-mq-deadline-disable-front_merges-by-default"
      "xanmod/0005-block-mq-deadline-increase-write-priority-to-improve"
      "xanmod/0006-vfs-decrease-rate-at-which-caches-are-reclaimed"
      "xanmod/0008-wait-allow-__wake_up_pollfree-from-GPL-modules"
      "xanmod/0009-file-export-file_close_fd-for-GPL-modules"
      "xanmod/0010-binder-give-binder_alloc-its-own-debug-mask-file"
      "xanmod/0011-binder-turn-into-loadable-module"
      "xanmod/0012-tcp-add-sysctl-to-skip-collapse-when-receive-buffer-"
      "xanmod/0014-dm-crypt-Disable-workqueues-for-crypto-ops"
      "zen/0009-mm-set-default-max-map-count-to-INT_MAX-5"
    ];

    latest =
      {
        isVanilla ? true,
      }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.latest}/${patch}.patch"
        )
        (
          [
            "bunker/0003-rust-allow-clang-native-randstruct-configs"
            "bunker/0007-enable-page_table_check_enforced-by-default"
            "bunker/0010-rust-add-backlight-device-abstraction"
            "clear/0006-init-reduce-default-timer-slack-to-50ns"
            "cachyos/0004-sched-ext"
            "cachyos/0010-block-reduce-BFQ-and-mq-deadline-lock-contention"
            "cachyos/0013-mm-add-missing-extern-declarations-for-le9-workingse"
            "cachyos/0014-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation"
            "cachyos/0018-drivers-net-add-Realtek-R8125-R8126-5GbE-driver"
            "xanmod/0001-sched-fair-set-tunable-latencies-to-unscaled"
            "xanmod/0007-locking-rwsem-spin-more-aggressively-before-cpu_rela"
            "zen/0006-cpufreq-remove-schedutil-dependency-on-Intel-AMD-P-S"
          ]
          ++ (kernel.patches.bunker.common { })
          ++ (lib.optionals isVanilla [
            "bunker/0001-init-add-CONFIG_BUNKER-base-config-item"
            "bunker/0004-enable-randstruct_full-by-default"
            "bunker/0005-mm-increase-VM_READAHEAD_PAGES-to-2MB"
            "bunker/0009-i2c-add-nct6775-smbus-driver-for-openrgb"
            "cachyos/0001-tcp-bbr3-add-BBRv3-congestion-control"
            "cachyos/0002-fixes-inline-sched-mm-tick-vtime-rcu-quirks"
            "cachyos/0006-block-add-ADIOS-Adaptive-Deadline-I-O-Scheduler"
            "cachyos/0008-media-add-v4l2loopback-virtual-video-device"
            "cachyos/0009-mm-add-Kconfig-defaults-for-compaction-and-dirty-pag"
            "cachyos/0012-sched-add-Piece-Of-Cake-fast-idle-CPU-selector"
            "cachyos/0015-drm-VESA-DSC-BPP-pass-through-timings"
            "cachyos/0016-kbuild-Add-Clang-Polly-polyhedral-loop-optimizer"
            "cachyos/0019-cpuidle-prefer-teo-over-menu-governor"
            "cachyos/0020-media-v4l2loopback-update-to-0.15.4"
            "clear/0002-tcp-raise-per-socket-write-memory-limit-to-16MB"
            "clear/0003-net-sock-increase-_SK_MEM_PACKETS-to-1024"
            "clear/0004-net-sock-batch-socket-memory-reclaim-in-sk_mem_uncha"
            "clear/0005-sched-fair-remove-upper-limit-on-cpu-number"
            "clear/0007-exit-use-mmput_async-to-reduce-exit-latency"
            "clear/0008-memcg-increase-MEMCG_CHARGE_BATCH-to-128"
            "clear/0010-sched-core-add-branch-hints-based-on-gcov-analysis"
            "clear/0011-readdir-add-unlikely-branch-hint-on-len-check"
            "clear/0012-pci-increase-PME-check-interval-to-4-seconds"
            "xanmod/0002-sched-add-yield_type-sysctl-to-reduce-or-disable-sch"
            "zen/0001-PCI-add-ACS-override-support"
            "zen/0004-drivers-initialize-ata-before-graphics"
            "zen/0005-input-evdev-use-call_rcu-when-detaching-client"
            "zen/0010-mm-stop-kswapd-early-when-nothing-s-waiting-for-it-t"
            "zen/0011-ahci-disable-staggered-spinup-by-default"
            "zen/0012-kernel-Kconfig.preempt-remove-EXPERT-conditional-on-"
            "zen/0013-block-use-BFQ-as-the-elevator-for-SQ-devices"
            "zen/0014-block-Clean-up-elevator_set_default"
            "zen/0015-mm-enable-background-reclaim-of-hugepages"
            "zen/0016-sched-eevdf-tune-for-interactivity"
            "zen/0017-mm-disable-unevictable-compaction"
            "zen/0018-mm-disable-watermark-boosting-by-default"
            "zen/0019-mm-swap-disable-swap-in-readahead"
            "zen/0020-block-use-Kyber-as-the-elevator-for-MQ-devices"
          ])
        )
      |> lib.sort lib.lessThan;

    lts =
      {
        isVanilla ? true,
      }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.lts}/${patch}.patch"
        )
        (
          [
            "cachyos/0017-mm-add-missing-extern-declarations-for-le9-workingse"
            "cachyos/0018-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation"
            "cachyos/0019-drm-VESA-DSC-BPP-pass-through-timings"
            "cachyos/0022-drivers-net-add-Realtek-R8125-R8126-5GbE-driver"
            "cachyos/0023-cpuidle-prefer-teo-over-menu-governor"
            "clear/0010-sched-core-add-branch-hints-based-on-gcov-analysis"
            "clear/0012-pci-increase-PME-check-interval-to-4-seconds"
            "upstream/0002-time-timecounter-inline-timecounter_cyc2time"
            "upstream/0003-x86-lib-inline-csum_ipv6_magic"
            "upstream/0004-x86-apic-inline-x2apic_send_IPI_dest"
            "upstream/0005-cpuidle-menu-remove-incorrect-unlikely-annotation"
            "upstream/0007-tcp-inline-tcp_filter"
            "upstream/0008-ipv6-optimize-fl6_update_dst"
            "upstream/0009-net_sched-sch_fq-rework-fq_gc-to-avoid-stack-canary"
            "upstream/0010-tcp-use-__skb_push-in-__tcp_transmit_skb"
            "upstream/0011-ipv6-do-not-use-skb_header_pointer-in-icmpv6_filter"
            "upstream/0012-tcp-split-tcp_check_space-in-two-parts"
            "upstream/0015-btf-optimize-type-lookup-with-binary-search"
            "upstream/0016-btf-verify-btf-sorting"
            "upstream/0019-mount-add-OPEN_TREE_NAMESPACE"
          ]
          ++ (kernel.patches.bunker.common { })
          ++ (
            if isVanilla then
              [
                "bunker/0004-enable-randstruct_full-by-default"
                "bunker/0005-mm-increase-VM_READAHEAD_PAGES-to-2MB"
                "bunker/0007-enable-page_table_check_enforced-by-default"
                "cachyos/0002-sched-Make-raw_spin_rq_unlock-inline"
                "cachyos/0003-sched-core-Make-finish_task_switch-and-its-subfuncti"
                "cachyos/0006-sched-ext"
                "cachyos/0012-media-add-v4l2loopback-virtual-video-device"
                "cachyos/0013-mm-add-Kconfig-defaults-for-compaction-and-dirty-pag"
                "cachyos/0016-sched-add-Piece-Of-Cake-fast-idle-CPU-selector"
                "cachyos/0020-kbuild-Add-Clang-Polly-polyhedral-loop-optimizer"
                "cachyos/0021-kbuild-dkms-clang-compatibility"
                "cachyos/0024-crypto"
                "clear/0002-tcp-raise-per-socket-write-memory-limit-to-16MB"
                "clear/0003-net-sock-increase-_SK_MEM_PACKETS-to-1024"
                "clear/0004-net-sock-batch-socket-memory-reclaim-in-sk_mem_uncha"
                "clear/0005-sched-fair-remove-upper-limit-on-cpu-number"
                "clear/0006-init-reduce-default-timer-slack-to-50ns"
                "clear/0007-exit-use-mmput_async-to-reduce-exit-latency"
                "clear/0008-memcg-increase-MEMCG_CHARGE_BATCH-to-128"
                "clear/0011-readdir-add-unlikely-branch-hint-on-len-check"
                "xanmod/0001-sched-fair-set-tunable-latencies-to-unscaled"
                "xanmod/0002-sched-add-yield_type-sysctl-to-reduce-or-disable-sch"
                "xanmod/0007-locking-rwsem-spin-more-aggressively-before-cpu_rela"
                "xanmod/0013-sched-wait-Do-accept-in-LIFO-order-for-cache-efficie"
                "zen/0004-drivers-initialize-ata-before-graphics"
                "zen/0005-input-evdev-use-call_rcu-when-detaching-client"
                "zen/0010-mm-stop-kswapd-early-when-nothing-s-waiting-for-it-t"
                "zen/0011-ahci-disable-staggered-spinup-by-default"
                "zen/0012-kernel-Kconfig.preempt-remove-EXPERT-conditional-on-"
                "zen/0014-block-Clean-up-elevator_set_default"
              ]
            else
              [
                "xanmod/0015-kbuild-add-sms-based-software-pipelining-flags"
              ]
          )
        )
      |> lib.sort lib.lessThan;
  };
}
