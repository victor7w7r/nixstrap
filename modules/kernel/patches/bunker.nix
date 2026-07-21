{ inputs, ... }:
{
  flake-file.inputs.bunker-patches = {
    url = "github:amaanq/bunker-patches";
    flake = false;
  };

  kernel.patches.bunker = rec {
    std = map (path: "${inputs.bunker-patches}/patches/6.18/${path}") [
      "bunker/0006-enable-kstack_erase-by-default.patch"
      "bunker/0008-disable-proc_kcore-by-default.patch"
      "clear/0001-net-dst-reduce-false-sharing-in-dst_entry.patch"
      "clear/0009-mm-compaction-increase-proactive-compaction-check-in.patch"
      "clear/0010-sched-core-add-branch-hints-based-on-gcov-analysis.patch"
      "clear/0012-pci-increase-PME-check-interval-to-4-seconds.patch"
      "cachyos/0017-mm-add-missing-extern-declarations-for-le9-workingse.patch"
      "cachyos/0018-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation.patch"
      "cachyos/0019-drm-VESA-DSC-BPP-pass-through-timings.patch"
      "cachyos/0022-drivers-net-add-Realtek-R8125-R8126-5GbE-driver.patch"
      "cachyos/0023-cpuidle-prefer-teo-over-menu-governor.patch"
      "grapheneos/0001-disable-ldisc_autoload-by-default.patch"
      "grapheneos/0002-disable-binfmt_misc-by-default.patch"
      "grapheneos/0004-disable-memory_hotplug-by-default.patch"
      "grapheneos/0005-usb-extend-deny_new_usb-to-gadget-interfaces.patch"
      "zen/0009-mm-set-default-max-map-count-to-INT_MAX-5.patch"
      "xanmod/0003-block-set-rq_affinity-to-force-complete-I-O-on-same-.patch"
      "xanmod/0004-block-mq-deadline-disable-front_merges-by-default.patch"
      "xanmod/0005-block-mq-deadline-increase-write-priority-to-improve.patch"
      "xanmod/0006-vfs-decrease-rate-at-which-caches-are-reclaimed.patch"
      "xanmod/0008-wait-allow-__wake_up_pollfree-from-GPL-modules.patch"
      "xanmod/0009-file-export-file_close_fd-for-GPL-modules.patch"
      "xanmod/0010-binder-give-binder_alloc-its-own-debug-mask-file.patch"
      "xanmod/0011-binder-turn-into-loadable-module.patch"
      "xanmod/0012-tcp-add-sysctl-to-skip-collapse-when-receive-buffer-.patch"
      "xanmod/0014-dm-crypt-Disable-workqueues-for-crypto-ops.patch"
      "xanmod/0015-kbuild-add-sms-based-software-pipelining-flags.patch"

      "upstream/0002-time-timecounter-inline-timecounter_cyc2time.patch"
      "upstream/0003-x86-lib-inline-csum_ipv6_magic.patch"
      "upstream/0004-x86-apic-inline-x2apic_send_IPI_dest.patch"
      "upstream/0005-cpuidle-menu-remove-incorrect-unlikely-annotation.patch"
      "upstream/0007-tcp-inline-tcp_filter.patch"
      "upstream/0008-ipv6-optimize-fl6_update_dst.patch"
      "upstream/0009-net_sched-sch_fq-rework-fq_gc-to-avoid-stack-canary.patch"
      "upstream/0010-tcp-use-__skb_push-in-__tcp_transmit_skb.patch"
      "upstream/0011-ipv6-do-not-use-skb_header_pointer-in-icmpv6_filter.patch"
      "upstream/0012-tcp-split-tcp_check_space-in-two-parts.patch"
      "upstream/0014-drm-amdgpu-use-GFP_ATOMIC-instead-of-NOWAIT-in-the-c.patch"
      "upstream/0015-btf-optimize-type-lookup-with-binary-search.patch"
      "upstream/0016-btf-verify-btf-sorting.patch"
      "upstream/0018-slab-introduce-kmalloc_flex-and-family.patch"
      "upstream/0019-mount-add-OPEN_TREE_NAMESPACE.patch"
    ];
    hardened =
      std
      ++ map (path: "${inputs.bunker-patches}/patches/6.18/hardened/${path}") [
        #"0001-add-sysctl-to-allow-disabling-unprivileged-CLONE_NEW.patch"
        #"0002-security-add-config-for-default-of-unprivileged_user.patch"
      ];
  };
}
