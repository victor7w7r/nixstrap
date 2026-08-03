{ inputs, ... }:
{
  flake-file.inputs.bunker-patches = {
    url = "github:amaanq/bunker-patches";
    flake = false;
  };

  kernel.patches.bunker = rec {
    std = map (patch: "${inputs.bunker-patches}/patches/7.1/${patch}") [
      "bunker/0003-rust-allow-clang-native-randstruct-configs.patch"
      "bunker/0006-enable-kstack_erase-by-default.patch"
      "bunker/0007-enable-page_table_check_enforced-by-default.patch"
      "bunker/0008-disable-proc_kcore-by-default.patch"
      "bunker/0010-rust-add-backlight-device-abstraction.patch"
      "clear/0001-net-dst-reduce-false-sharing-in-dst_entry.patch"
      "clear/0006-init-reduce-default-timer-slack-to-50ns.patch"
      "clear/0009-mm-compaction-increase-proactive-compaction-check-in.patch"
      "cachyos/0004-sched-ext.patch"
      "cachyos/0010-block-reduce-BFQ-and-mq-deadline-lock-contention.patch"
      "cachyos/0013-mm-add-missing-extern-declarations-for-le9-workingse.patch"
      "cachyos/0014-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation.patch"
      "cachyos/0018-drivers-net-add-Realtek-R8125-R8126-5GbE-driver.patch"
      "grapheneos/0001-disable-ldisc_autoload-by-default.patch"
      "grapheneos/0004-disable-memory_hotplug-by-default.patch"
      "grapheneos/0005-usb-extend-deny_new_usb-to-gadget-interfaces.patch"
      "xanmod/0001-sched-fair-set-tunable-latencies-to-unscaled.patch"
      "xanmod/0003-block-set-rq_affinity-to-force-complete-I-O-on-same-.patch"
      "xanmod/0004-block-mq-deadline-disable-front_merges-by-default.patch"
      "xanmod/0005-block-mq-deadline-increase-write-priority-to-improve.patch"
      "xanmod/0006-vfs-decrease-rate-at-which-caches-are-reclaimed.patch"
      "xanmod/0007-locking-rwsem-spin-more-aggressively-before-cpu_rela.patch"
      "xanmod/0008-wait-allow-__wake_up_pollfree-from-GPL-modules.patch"
      "xanmod/0009-file-export-file_close_fd-for-GPL-modules.patch"
      "xanmod/0010-binder-give-binder_alloc-its-own-debug-mask-file.patch"
      "xanmod/0011-binder-turn-into-loadable-module.patch"
      "xanmod/0012-tcp-add-sysctl-to-skip-collapse-when-receive-buffer-.patch"
      "xanmod/0014-dm-crypt-Disable-workqueues-for-crypto-ops.patch"
      "zen/0006-cpufreq-remove-schedutil-dependency-on-Intel-AMD-P-S.patch"
      "zen/0009-mm-set-default-max-map-count-to-INT_MAX-5.patch"
    ];
    hardened =
      std
      ++ map (path: "${inputs.bunker-patches}/patches/7.1/hardened/${path}") [
        #"0001-add-sysctl-to-allow-disabling-unprivileged-CLONE_NEW.patch"
        #"0002-security-add-config-for-default-of-unprivileged_user.patch"
      ];
  };
}
