{
  inputs,
  kernel,
  lib,
  ...
}:
{
  flake-file.inputs =
    "https://git.staropensource.de/StarOpenSource/Linux-Tachyon/archive"
    |> (url: {
      tachyon-patches-latest = {
        url = "${url}/25bfa5ba12783e5e1b0a15cfac570b532f711329.tar.gz";
        flake = false;
      };
      tachyon-patches-lts = {
        url = "${url}/bab8787a6987ad7b38e39c4d6bbc75315a44329a.tar.gz";
        flake = false;
      };
      tachyon-patches-legacy = {
        url = "${url}/74e253325b575983a85a4d17b60a03af7fd02a09.tar.gz";
        flake = false;
      };
    });

  kernel.patches.tachyon = {
    common = { }: [
      "0102-increase-the-ext4-default-commit-age"
      "0108-smpboot-reuse-timer-calibration"
      "0111-ipv4-tcp-allow-the-memory-tuning-for-tcp-to-go-a-lit"
      "0112-init-wait-for-partition-and-retry-scan"
      "0113-print-fsync-count-for-bootchart"
      "0114-add-boot-option-to-allow-unsigned-modules"
      "0115-enable-stateless-firmware-loading"
      "0116-migrate-some-systemd-defaults-to-the-kernel-defaults"
      "0120-do-accept-in-LIFO-order-for-cache-efficiency"
      "0122-ata-libahci-ignore-staggered-spin-up"
      "0125-nvme-workaround"
      "0126-don-t-report-an-error-if-PowerClamp-run-on-other-CPU"
      "0127-lib-raid6-add-patch"
      "0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s"
      "0133-novector"
      "0135-initcall-only-print-non-zero-initcall-debug-to-speed"
      "epp-retune"
      "libsgrowdown"
      "mmput_async"
    ];

    latest =
      {
        isVanilla ? false,
      }:
      (
        map (patch: "${inputs.tachyon-patches-latest}/patches/${patch}.patch") [
          "0001-ACPI-processor-Disable-bus-master-check-for-AMD"
          "0001-dma-buf-sync_file-Speed-up-ioctl-by-omitting-debug-n"
          "0001-kernfs-Avoid-dynamic-memory-allocation-for-small-wri"
          "0002-drm-amd-display_Fix_high_busy_wait_load_in_dmub_srv_wait_for_idle"
          "0002-kernel-Eliminate-dynamic-memory-allocation-in-prctl_"
          "0002-mbcache-Speed-up-cache-entry-creation"
          "0003-mm-stop-kswapd-early-when-nothings-wa"
          "0003-sched-core-Skip-superfluous-acquire-barrier-in-ttwu"
          "0004-mm-dont-stop-kswapd-on-a-per-node-bas"
          "0004-sched-fair-Always-update-CPU-capacity-when-load-bala"
          "0004-sched-fair-Compile-out-NUMA-code-entirely-when-NUMA-"
          "0005-sched-fair-Don-t-needlessly-migrate-a-lone-task-to-a"
          "0006-sched-fair-Iterate-in-ascending-CPU-order-when-doing"
          "0050-Revert-ext4-do-not-create-EA-inode-under-buffer-lock"
          "0104-pci-pme-wakeups"
          "0128-itmt_epb-use-epb-to-scale-itmt"
          "0130-itmt2-ADL-fixes"
          "0136-crypto-kdf-make-the-module-init-call-a-late-init-cal"
          "0158-clocksource-only-perform-extended-clocksource-checks"
          "0161-ACPI-align-slab-buffers-for-improved-memory-performa"
          "0163-thermal-intel-powerclamp-check-MWAIT-first-use-pr_wa"
          "0166-sched-fair-remove-upper-limit-on-cpu-number"
          "0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-"
          "0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127"
          "better_idle_balance"
          "posted_msi"
          "ratelimit-sched-yield"
          "scale-net-alloc"
        ]
        ++ (kernel.patches.tachyon.common { })
        ++ (lib.optionals isVanilla (
          map (patch: "${inputs.tachyon-patches-latest}/patches/${patch}.patch") [
            #"0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an"
            #"0002-sched-core-add-some-branch-hints-based-on-gcov-analy"
            #"0002-mm-disable-proactive-compaction-by-de"
            #"0001-mm-disable-watermark-boosting-by-defa"
            #"0107-bootstats-add-printk-s-to-measure-boot-time-in-more-"
            #"0110-give-rdrand-some-credit"
            #"0117-xattr-allow-setting-user.-attributes-on-symlinks-by-"
            #"0118-add-scheduler-turbo3-patch"
            #"0121-locking-rwsem-spin-faster"
            #"0129-mm-wakeups-remove-a-wakeup"
            #"0132-prezero-20220308"
            #"0162-extra-optmization-flags"
            #"0169-mm-mincore-improve-performance-by-adding-an-unlikely"
            #"0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-"
            #"netscale"
            #"revert-regression"
            #"scale"
            #"slack"
          ]
        ))
      )
      |> lib.sort lib.lessThan;
    lts =
      {
        isVanilla ? false,
      }:
      (
        map (patch: "${inputs.tachyon-patches-lts}/patches/${patch}.patch") [
          "0003-mm-stop-kswapd-early-when-nothings-wa"
          "0050-Revert-ext4-do-not-create-EA-inode-under-buffer-lock"
          "0117-xattr-allow-setting-user.-attributes-on-symlinks-by-"
          "0136-crypto-kdf-make-the-module-init-call-a-late-init-cal"
          "0158-clocksource-only-perform-extended-clocksource-checks"
          "0161-ACPI-align-slab-buffers-for-improved-memory-performa"
          "0163-thermal-intel-powerclamp-check-MWAIT-first-use-pr_wa"
          "0166-sched-fair-remove-upper-limit-on-cpu-number"
          "0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-"
          "0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-"
          "0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127"
          "0175-readdir-add-unlikely-hint-on-len-check"
          "slack"
          "better_idle_balance"
          "posted_msi"
          "ratelimit-sched-yield"
          "scale-net-alloc"
        ]
        ++ (kernel.patches.tachyon.common { })
        ++ (lib.optionals isVanilla (
          map (patch: "${inputs.tachyon-patches-latest}/patches/${patch}.patch") [
            #"0001-add-umonitor-umwait-C0.x-C-states"
            #"0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an"
            #"0001-sched-migrate"
            #"0002-sched-core-add-some-branch-hints-based-on-gcov-analy"
            #"0002-mm-disable-proactive-compaction-by-de"
            #"0005-mm-increment-kswapd_waiters-for-throt" #ERROR
            #"0002-sched-migrate"
            #"0107-bootstats-add-printk-s-to-measure-boot-time-in-more-"
            #"0110-give-rdrand-some-credit"
            #"0118-add-scheduler-turbo3-patch"
            #"0129-mm-wakeups-remove-a-wakeup"
            #"0132-prezero-20220308"
            #"0162-extra-optmization-flags"
            #"0175-readdir-add-unlikely-hint-on-len-check"
            #"netscale"
            #"revert-regression"
            #"scale"
          ]
        ))
      )
      |> lib.sort lib.lessThan;
    legacy = (
      map (patch: "${inputs.tachyon-patches-legacy}/patches/${patch}.patch") [
        #"0001-add-umonitor-umwait-C0.x-C-states"
        "0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an"
        "0001-powerbump-functionality"
        "0001-sched-cpuset-Fix-dl_cpu_busy-panic-due-to-empty-cs-c"
        "0001-sched-migrate"
        "0001-sched-numa-Initialise-numa_migrate_retry"
        "0002-add-networking-support-for-powerbump"
        "0002-exit-Fix-typo-in-comment-s-sub-theads-sub-threads"
        "0002-sched-core-add-some-branch-hints-based-on-gcov-analy"
        "0002-sched-migrate"
        "0002-sched-numa-Do-not-swap-tasks-between-nodes-when-spar"
        "0003-futex-bump"
        "0003-sched-numa-Apply-imbalance-limitations-consistently"
        "0003-sched-rt-Fix-Sparse-warnings-due-to-undefined-rt.c-d"
        "0004-sched-core-Do-not-requeue-task-on-CPU-excluded-from-"
        "0004-sched-numa-Adjust-imb_numa_nr-to-a-better-approximat"
        "0005-sched-fair-Consider-CPU-affinity-when-allowing-NUMA-"
        "0006-sched-fair-Optimize-and-simplify-rq-leaf_cfs_rq_list"
        "0007-sched-deadline-Use-proc_douintvec_minmax-limit-minim"
        "0008-sched-Allow-newidle-balancing-to-bail-out-of-load_ba"
        "0009-sched-Fix-the-check-of-nr_running-at-queue-wakelist"
        "0010-sched-Remove-the-limitation-of-WF_ON_CPU-on-wakelist"
        "0013-selftests-rseq-check-if-libc-rseq-support-is-registe"
        "0014-sched-fair-Remove-redundant-word"
        "0015-sched-Remove-unused-function-group_first_cpu"
        "0016-sched-only-perform-capability-check-on-privileged-op"
        "0017-sched-fair-Introduce-SIS_UTIL-to-search-idle-CPU-bas"
        "0018-sched-fair-Provide-u64-read-for-32-bits-arch-helper"
        "0019-sched-fair-Decay-task-PELT-values-during-wakeup-migr"
        "0020-sched-drivers-Remove-max-param-from-effective_cpu_ut"
        "0021-sched-fair-Rename-select_idle_mask-to-select_rq_mask"
        "0022-sched-fair-Use-the-same-cpumask-per-PD-throughout-fi"
        "0023-sched-fair-Remove-task_util-from-effective-utilizati"
        "0024-sched-fair-Remove-the-energy-margin-in-feec"
        "0025-sched-core-add-forced-idle-accounting-for-cgroups"
        "0026-sched-core-Use-try_cmpxchg-in-set_nr_-and_not-if-_po"
        "0027-sched-fair-fix-case-with-reduced-capacity-CPU"
        "0028-sched-core-Always-flush-pending-blk_plug"
        "0029-nohz-full-sched-rt-Fix-missed-tick-reenabling-bug-in"
        "0030-sched-core-Fix-the-bug-that-task-won-t-enqueue-into-"
        "0031-rseq-Deprecate-RSEQ_CS_FLAG_NO_RESTART_ON_-flags"
        "0032-rseq-Kill-process-when-unknown-flags-are-encountered"
        "0104-pci-pme-wakeups"
        "0105-ksm-wakeups"
        "0107-bootstats-add-printk-s-to-measure-boot-time-in-more-"
        "0109-initialize-ata-before-graphics"
        "0117-xattr-allow-setting-user.-attributes-on-symlinks-by-"
        "0121-locking-rwsem-spin-faster"
        "0123-print-CPU-that-faults"
        "0127-lib-raid6-add"
        "0129-mm-wakeups-remove-a-wakeup"
        "0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s"
        "0132-prezero-20220308"
        "0134-md-raid6-algorithms-scale-test-duration-for-speedier"
        "0135-initcall-only-print-non-zero-initcall-debug-to-speed"
        "iommu"
        "kdf-boottime"
        "kvm-printk"
        "libsgrowdown"
        "mm-lru_cache_disable-use-synchronize_rcu_expedited"
        "mmput_async"
        "netscale"
        "scale"
        "tcptuning"
      ]
      ++ (kernel.patches.tachyon.common { })
    );
  };
}
