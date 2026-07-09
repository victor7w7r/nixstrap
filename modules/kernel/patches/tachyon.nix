{
  kernel.patches.tachyon =
    pkgs:
    rec {
      patches =
        with (pkgs.lib.trivial.importJSON ./patches.json).tachyon;
        pkgs.fetchgit { inherit url rev sha256; };
      common = map (path: "${patches}/patches/${path}") [
        #"0001-add-umonitor-umwait-C0.x-C-states.patch"
        #"0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an.patch"
        #"0001-sched-migrate.patch"
        #"0002-sched-core-add-some-branch-hints-based-on-gcov-analy.patch"
        #"0002-mm-disable-proactive-compaction-by-de.patch"
        "0003-mm-stop-kswapd-early-when-nothings-wa.patch"
        #"0005-mm-increment-kswapd_waiters-for-throt.patch" #ERROR
        #"0002-sched-migrate.patch"
        "0050-Revert-ext4-do-not-create-EA-inode-under-buffer-lock.patch"
        "0102-increase-the-ext4-default-commit-age.patch"
        #"0107-bootstats-add-printk-s-to-measure-boot-time-in-more-.patch"
        "0108-smpboot-reuse-timer-calibration.patch"
        #"0110-give-rdrand-some-credit.patch"
        "0111-ipv4-tcp-allow-the-memory-tuning-for-tcp-to-go-a-lit.patch"
        "0112-init-wait-for-partition-and-retry-scan.patch"
        "0113-print-fsync-count-for-bootchart.patch"
        "0114-add-boot-option-to-allow-unsigned-modules.patch"
        "0115-enable-stateless-firmware-loading.patch"
        "0116-migrate-some-systemd-defaults-to-the-kernel-defaults.patch"
        "0117-xattr-allow-setting-user.-attributes-on-symlinks-by-.patch"
        #"0118-add-scheduler-turbo3-patch.patch"
        "0120-do-accept-in-LIFO-order-for-cache-efficiency.patch"
        "0122-ata-libahci-ignore-staggered-spin-up.patch"
        "0125-nvme-workaround.patch"
        "0126-don-t-report-an-error-if-PowerClamp-run-on-other-CPU.patch"
        "0127-lib-raid6-add-patch.patch"
        #"0129-mm-wakeups-remove-a-wakeup.patch"
        "0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s.patch"
        #"0132-prezero-20220308.patch"
        "0133-novector.patch"
        "0135-initcall-only-print-non-zero-initcall-debug-to-speed.patch"
        "0136-crypto-kdf-make-the-module-init-call-a-late-init-cal.patch"
        "0161-ACPI-align-slab-buffers-for-improved-memory-performa.patch"
        #"0162-extra-optmization-flags.patch"
        "0163-thermal-intel-powerclamp-check-MWAIT-first-use-pr_wa.patch"
        "0166-sched-fair-remove-upper-limit-on-cpu-number.patch"
        "0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-.patch"
        "0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-.patch"
        "0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127.patch"
        "0175-readdir-add-unlikely-hint-on-len-check.patch"
        #"0175-readdir-add-unlikely-hint-on-len-check.patch"
        "better_idle_balance.patch"
        "epp-retune.patch"
        "libsgrowdown.patch"
        "mmput_async.patch"
        #"netscale.patch"
        "posted_msi.patch"
        "ratelimit-sched-yield.patch"
        #"revert-regression.patch"
        "scale-net-alloc.patch"
        #"scale.patch"
        "slack.patch"
      ];
    }
    |> (tachyon: {
      std =
        tachyon.common
        ++ map (path: "${tachyon.patches}/patches/${path}") [
          "0128-itmt_epb-use-epb-to-scale-itmt.patch"
        ];
      gaming =
        tachyon.common
        ++ map (path: "${tachyon.patches}/patches/${path}") [
          "0158-clocksource-only-perform-extended-clocksource-checks.patch"
        ];
    });
}
