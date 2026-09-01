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
    });

  kernel.patches.tachyon = {
    common =
      { source }:
      map (patch: "${source}/patches/${patch}.patch") [
        "0111-ipv4-tcp-allow-the-memory-tuning-for-tcp-to-go-a-lit"
        "0112-init-wait-for-partition-and-retry-scan"
        "0113-print-fsync-count-for-bootchart"
        "0115-enable-stateless-firmware-loading"
        "0116-migrate-some-systemd-defaults-to-the-kernel-defaults"
        "0120-do-accept-in-LIFO-order-for-cache-efficiency"
        "0126-don-t-report-an-error-if-PowerClamp-run-on-other-CPU"
        "0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s"
        "0135-initcall-only-print-non-zero-initcall-debug-to-speed"
        "0136-crypto-kdf-make-the-module-init-call-a-late-init-cal"
        "0166-sched-fair-remove-upper-limit-on-cpu-number"
        "0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-"
        "better_idle_balance"
        "libsgrowdown"
        "mmput_async"
        "ratelimit-sched-yield"
        "scale-net-alloc"
      ];

    common-x86 =
      { source }:
      map (patch: "${source}/patches/${patch}.patch") [
        "0108-smpboot-reuse-timer-calibration"
        "0114-add-boot-option-to-allow-unsigned-modules"
        "0128-itmt_epb-use-epb-to-scale-itmt"
        "0130-itmt2-ADL-fixes"
        "0158-clocksource-only-perform-extended-clocksource-checks"
        "0161-ACPI-align-slab-buffers-for-improved-memory-performa"
        "epp-retune"
        "posted_msi"
      ]
      ++ kernel.patches.tachyon.common { inherit source; };

    latest =
      { }:
      map (patch: "${inputs.tachyon-patches-latest}/patches/${patch}.patch") [
        "0001-dma-buf-sync_file-Speed-up-ioctl-by-omitting-debug-n"
        "0001-kernfs-Avoid-dynamic-memory-allocation-for-small-wri"
        "0002-kernel-Eliminate-dynamic-memory-allocation-in-prctl_"
        "0002-mbcache-Speed-up-cache-entry-creation"
        "0003-sched-core-Skip-superfluous-acquire-barrier-in-ttwu"
        "0004-sched-fair-Always-update-CPU-capacity-when-load-bala"
        "0004-sched-fair-Compile-out-NUMA-code-entirely-when-NUMA-"
        "0006-sched-fair-Iterate-in-ascending-CPU-order-when-doing"
        "0050-Revert-ext4-do-not-create-EA-inode-under-buffer-lock"
        "0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127"
      ];

    lts =
      { }:
      map (patch: "${inputs.tachyon-patches-lts}/patches/${patch}.patch") [
        "0003-mm-stop-kswapd-early-when-nothings-wa"
        "0050-Revert-ext4-do-not-create-EA-inode-under-buffer-lock"
        "0117-xattr-allow-setting-user.-attributes-on-symlinks-by-"
        "0122-ata-libahci-ignore-staggered-spin-up"
        "0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-"
        "0175-readdir-add-unlikely-hint-on-len-check"
        "slack"
      ];
  };
}
