{
  inputs,
  lib,
  kernel-versions,
  ...
}:
{
  flake-file.inputs.bunker-patches = {
    url = "github:amaanq/bunker-patches";
    flake = false;
  };

  kernel.patches.bunker = {
    common =
      {
        isLts ? true,
      }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${
            lib.versions.majorMinor (if isLts then kernel-versions.lts else kernel-versions.latest)
          }/${patch}.patch"
        )
        [
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

    hardening =
      { }:
      map (
        patch:
        "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.lts}/${patch}.patch"
      ) [ "bunker/0006-enable-kstack_erase-by-default" ];

    latest-x86 =
      { }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.latest}/${patch}.patch"
        )
        [
          "cachyos/0014-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation"
          "zen/0006-cpufreq-remove-schedutil-dependency-on-Intel-AMD-P-S"
        ];

    latest =
      { }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.latest}/${patch}.patch"
        )
        [
          #"clear/0006-init-reduce-default-timer-slack-to-50ns"
          "cachyos/0010-block-reduce-BFQ-and-mq-deadline-lock-contention"
          "cachyos/0013-mm-add-missing-extern-declarations-for-le9-workingse"
          "xanmod/0001-sched-fair-set-tunable-latencies-to-unscaled"
          "xanmod/0007-locking-rwsem-spin-more-aggressively-before-cpu_rela"
        ];

    lts-x86 =
      { }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.lts}/${patch}.patch"
        )
        [
          "cachyos/0018-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation"
          "upstream/0003-x86-lib-inline-csum_ipv6_magic"
          "upstream/0004-x86-apic-inline-x2apic_send_IPI_dest"
        ];

    lts =
      { }:
      map
        (
          patch:
          "${inputs.bunker-patches}/patches/${lib.versions.majorMinor kernel-versions.lts}/${patch}.patch"
        )
        [
          "cachyos/0017-mm-add-missing-extern-declarations-for-le9-workingse"
          "cachyos/0023-cpuidle-prefer-teo-over-menu-governor"
          "clear/0010-sched-core-add-branch-hints-based-on-gcov-analysis"
          "clear/0012-pci-increase-PME-check-interval-to-4-seconds"
          "upstream/0002-time-timecounter-inline-timecounter_cyc2time"
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
          "xanmod/0015-kbuild-add-sms-based-software-pipelining-flags"
        ];
  };
}
