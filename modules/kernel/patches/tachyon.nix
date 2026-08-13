{ inputs, kernel, ... }:
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
      #"0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an"
      #"0002-sched-core-add-some-branch-hints-based-on-gcov-analy"
      #"0002-mm-disable-proactive-compaction-by-de"
      "0001-ACPI-processor-Disable-bus-master-check-for-AMD"
      "0001-dma-buf-sync_file-Speed-up-ioctl-by-omitting-debug-n"
      #"0001-mm-disable-watermark-boosting-by-defa"
      "0001-kernfs-Avoid-dynamic-memory-allocation-for-small-wri"
      "0002-kernel-Eliminate-dynamic-memory-allocation-in-prctl_"
      "0002-drm-amd-display_Fix_high_busy_wait_load_in_dmub_srv_wait_for_idle"
      "0002-mbcache-Speed-up-cache-entry-creation"
      "0003-mm-stop-kswapd-early-when-nothings-wa"
      "0004-mm-dont-stop-kswapd-on-a-per-node-bas"
      "0003-sched-core-Skip-superfluous-acquire-barrier-in-ttwu"
      "0004-sched-fair-Always-update-CPU-capacity-when-load-bala"
      "0004-sched-fair-Compile-out-NUMA-code-entirely-when-NUMA-"
      "0005-sched-fair-Don-t-needlessly-migrate-a-lone-task-to-a"
      "0006-sched-fair-Iterate-in-ascending-CPU-order-when-doing"
      "0050-Revert-ext4-do-not-create-EA-inode-under-buffer-lock"
      "0102-increase-the-ext4-default-commit-age"
      "0104-pci-pme-wakeups"
      #"0107-bootstats-add-printk-s-to-measure-boot-time-in-more-"
      "0108-smpboot-reuse-timer-calibration"
      #"0110-give-rdrand-some-credit"
      "0111-ipv4-tcp-allow-the-memory-tuning-for-tcp-to-go-a-lit"
      "0112-init-wait-for-partition-and-retry-scan"
      "0113-print-fsync-count-for-bootchart"
      "0114-add-boot-option-to-allow-unsigned-modules"
      "0115-enable-stateless-firmware-loading"
      "0116-migrate-some-systemd-defaults-to-the-kernel-defaults"
      #"0117-xattr-allow-setting-user.-attributes-on-symlinks-by-"
      #"0118-add-scheduler-turbo3-patch"
      "0120-do-accept-in-LIFO-order-for-cache-efficiency"
      #"0121-locking-rwsem-spin-faster"
      "0122-ata-libahci-ignore-staggered-spin-up"
      "0125-nvme-workaround"
      "0126-don-t-report-an-error-if-PowerClamp-run-on-other-CPU"
      "0127-lib-raid6-add-patch"
      "0128-itmt_epb-use-epb-to-scale-itmt"
      #"0129-mm-wakeups-remove-a-wakeup"
      "0130-itmt2-ADL-fixes"
      "0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s"
      #"0132-prezero-20220308"
      "0133-novector"
      "0135-initcall-only-print-non-zero-initcall-debug-to-speed"
      "0136-crypto-kdf-make-the-module-init-call-a-late-init-cal"
      "0158-clocksource-only-perform-extended-clocksource-checks"
      "0161-ACPI-align-slab-buffers-for-improved-memory-performa"
      #"0162-extra-optmization-flags"
      "0163-thermal-intel-powerclamp-check-MWAIT-first-use-pr_wa"
      "0166-sched-fair-remove-upper-limit-on-cpu-number"
      "0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-"
      #"0169-mm-mincore-improve-performance-by-adding-an-unlikely"
      #"0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-"
      "0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127"
      "better_idle_balance"
      "epp-retune"
      "libsgrowdown"
      "mmput_async"
      #"netscale"
      "posted_msi"
      "ratelimit-sched-yield"
      #"revert-regression"
      "scale-net-alloc"
      #"scale"
      #"slack"
    ];

    latest = (
      map (patch: "${inputs.tachyon-patches-latest}/patches/${patch}.patch") [ ]
      ++ (kernel.patches.tachyon.common { })
    );
    lts = (
      map (patch: "${inputs.tachyon-patches-lts}/patches/${patch}.patch") [ ]
      ++ (kernel.patches.tachyon.common { })
    );
    legacy = (
      map (patch: "${inputs.tachyon-patches-legacy}/patches/${patch}.patch") [ ]
      ++ (kernel.patches.tachyon.common { })
    );
  };
}
