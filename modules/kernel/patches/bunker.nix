{ inputs, lib, ... }:
{
  flake-file.inputs.bunker-patches = {
    url = "github:amaanq/bunker-patches";
    flake = false;
  };

  kernel.patches.bunker = {
    latest = map (patch: "${inputs.bunker-patches}/patches/7.1/${patch}.patch") [
      "bunker/0003-rust-allow-clang-native-randstruct-configs"
      "bunker/0006-enable-kstack_erase-by-default"
      "bunker/0007-enable-page_table_check_enforced-by-default"
      "bunker/0008-disable-proc_kcore-by-default"
      "bunker/0010-rust-add-backlight-device-abstraction"
      "clear/0001-net-dst-reduce-false-sharing-in-dst_entry"
      "clear/0006-init-reduce-default-timer-slack-to-50ns"
      "clear/0009-mm-compaction-increase-proactive-compaction-check-in"
      "cachyos/0004-sched-ext"
      "cachyos/0010-block-reduce-BFQ-and-mq-deadline-lock-contention"
      "cachyos/0013-mm-add-missing-extern-declarations-for-le9-workingse"
      "cachyos/0014-x86-cpu-bugs-VMSCAPE-BHB-clear-mitigation"
      "cachyos/0018-drivers-net-add-Realtek-R8125-R8126-5GbE-driver"
      "grapheneos/0001-disable-ldisc_autoload-by-default"
      "grapheneos/0004-disable-memory_hotplug-by-default"
      "xanmod/0001-sched-fair-set-tunable-latencies-to-unscaled"
      "xanmod/0003-block-set-rq_affinity-to-force-complete-I-O-on-same-"
      "xanmod/0004-block-mq-deadline-disable-front_merges-by-default"
      "xanmod/0005-block-mq-deadline-increase-write-priority-to-improve"
      "xanmod/0006-vfs-decrease-rate-at-which-caches-are-reclaimed"
      "xanmod/0007-locking-rwsem-spin-more-aggressively-before-cpu_rela"
      "xanmod/0008-wait-allow-__wake_up_pollfree-from-GPL-modules"
      "xanmod/0009-file-export-file_close_fd-for-GPL-modules"
      "xanmod/0010-binder-give-binder_alloc-its-own-debug-mask-file"
      "xanmod/0011-binder-turn-into-loadable-module"
      "xanmod/0012-tcp-add-sysctl-to-skip-collapse-when-receive-buffer-"
      "xanmod/0014-dm-crypt-Disable-workqueues-for-crypto-ops"
      "zen/0006-cpufreq-remove-schedutil-dependency-on-Intel-AMD-P-S"
      "zen/0009-mm-set-default-max-map-count-to-INT_MAX-5"
    ];
    lts =
      {
        isVanilla ? true,
      }:
      (
        map (patch: "${inputs.bunker-patches}/patches/6.18/${patch}.patch") [

        ]
        ++ lib.optionals isVanilla [ ]
      );
  };
}
