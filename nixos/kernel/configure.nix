{
  host,
  lib,
  pkgs,
  helpers,
  linux_6_18,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux.version;
  hardened = host == "v7w7r-youyeetoox1";
  config = import ./config { inherit host; };

  specialization =
    if host == "v7w7r-macmini81" then
      "-t2"
    else if host == "v7w7r-youyeetoox1" then
      "-server"
    else if host == "v7w7r-rc71l" then
      "-handheld"
    else if host == "v7w7r-higole" then
      "-lowperf"
    else
      "";

  fetch = pkgs.callPackage ./fetch.nix {
    inherit kernelData majorMinor hardened;
  };
  localVer = "-v7w7r${specialization}${if hardened then "-hardened" else ""}-native";

  patches = [
    "${fetch.patches}/${majorMinor}/0003-bbr3.patch"
    "${fetch.patches}/${majorMinor}/0004-cachy.patch"
    "${fetch.patches}/${majorMinor}/0005-crypto.patch"
    "${fetch.patches}/${majorMinor}/0006-fixes.patch"
    "${fetch.patches}/${majorMinor}/misc/0001-clang-polly.patch"
    "${fetch.patches}/${majorMinor}/misc/dkms-clang.patch"
    "${fetch.patches}/${majorMinor}/misc/poc-selector.patch"
    "${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
    "${fetch.patches}/${majorMinor}/misc/nap-governor.patch"
    #"${fetch.tkg}/linux-tkg-patches/${majorMinor}/0006-add-acs-overrides_iommu.patch"
    #"${fetch.tkg}/linux-tkg-patches/${majorMinor}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch"
    #"${fetch.tkg}/linux-tkg-patches/${majorMinor}/0003-glitched-cfs.patch"
    #"${fetch.tkg}/linux-tkg-patches/${majorMinor}/0013-optimize_harder_O3.patch"
    #"${fetch.tachyon}/patches/0001-add-umonitor-umwait-C0.x-C-states.patch"
    #"${fetch.tachyon}/patches/0001-dma-buf-sync_file-Speed-up-ioctl-by-omitting-debug-n.patch"
    #"${fetch.tachyon}/patches/0001-kernfs-Avoid-dynamic-memory-allocation-for-small-wri.patch"
    #"${fetch.tachyon}/patches/0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an.patch"
    "${fetch.tachyon}/patches/0002-kernel-Eliminate-dynamic-memory-allocation-in-prctl_.patch"
    "${fetch.tachyon}/patches/0002-mm-disable-proactive-compaction-by-de.patch"
    "${fetch.tachyon}/patches/0002-sched-core-add-some-branch-hints-based-on-gcov-analy.patch"
    "${fetch.tachyon}/patches/0002-sched-Disable-TTWU_QUEUE.patch"
    "${fetch.tachyon}/patches/0003-mm-Omit-RCU-read-lock-in-list_lru_count_one-when-RCU.patch"
    "${fetch.tachyon}/patches/0003-mm-stop-kswapd-early-when-nothings-wa.patch"
    "${fetch.tachyon}/patches/0003-sched-core-Skip-superfluous-acquire-barrier-in-ttwu.patch"
    "${fetch.tachyon}/patches/0004-sched-fair-Always-update-CPU-capacity-when-load-bala.patch"
    "${fetch.tachyon}/patches/0004-sched-fair-Compile-out-NUMA-code-entirely-when-NUMA-.patch"
    "${fetch.tachyon}/patches/0005-sched-fair-Don-t-needlessly-migrate-a-lone-task-to-a.patch"
    "${fetch.tachyon}/patches/0006-sched-fair-Iterate-in-ascending-CPU-order-when-doing.patch"
    "${fetch.tachyon}/patches/0007-sched-fair-Remove-throughput-optimization-that-keeps.patch"
    "${fetch.tachyon}/patches/0104-pci-pme-wakeups.patch"
    "${fetch.tachyon}/patches/0107-bootstats-add-printk-s-to-measure-boot-time-in-more-.patch"
    "${fetch.tachyon}/patches/0108-smpboot-reuse-timer-calibration.patch"
    "${fetch.tachyon}/patches/0109-initialize-ata-before-graphics.patch"
    "${fetch.tachyon}/patches/0110-give-rdrand-some-credit.patch"
    "${fetch.tachyon}/patches/0111-ipv4-tcp-allow-the-memory-tuning-for-tcp-to-go-a-lit.patch"
    "${fetch.tachyon}/patches/0112-init-wait-for-partition-and-retry-scan.patch"
    "${fetch.tachyon}/patches/0113-print-fsync-count-for-bootchart.patch"
    "${fetch.tachyon}/patches/0114-add-boot-option-to-allow-unsigned-modules.patch"
    "${fetch.tachyon}/patches/0115-enable-stateless-firmware-loading.patch"
    "${fetch.tachyon}/patches/0116-migrate-some-systemd-defaults-to-the-kernel-defaults.patch"
    "${fetch.tachyon}/patches/0117-xattr-allow-setting-user.-attributes-on-symlinks-by-.patch"
    "${fetch.tachyon}/patches/0118-add-scheduler-turbo3-patch.patch"
    "${fetch.tachyon}/patches/0120-do-accept-in-LIFO-order-for-cache-efficiency.patch"
    "${fetch.tachyon}/patches/0121-locking-rwsem-spin-faster.patch"
    "${fetch.tachyon}/patches/0122-ata-libahci-ignore-staggered-spin-up.patch"
    "${fetch.tachyon}/patches/0125-nvme-workaround.patch"
    "${fetch.tachyon}/patches/0127-lib-raid6-add-patch.patch"
    "${fetch.tachyon}/patches/0129-mm-wakeups-remove-a-wakeup.patch"
    "${fetch.tachyon}/patches/0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s.patch"
    "${fetch.tachyon}/patches/0132-prezero-20220308.patch"
    "${fetch.tachyon}/patches/0135-initcall-only-print-non-zero-initcall-debug-to-speed.patch"
    "${fetch.tachyon}/patches/0136-crypto-kdf-make-the-module-init-call-a-late-init-cal.patch"
    "${fetch.tachyon}/patches/0161-ACPI-align-slab-buffers-for-improved-memory-performa.patch"
    "${fetch.tachyon}/patches/0162-extra-optmization-flags.patch"
    "${fetch.tachyon}/patches/0166-sched-fair-remove-upper-limit-on-cpu-number.patch"
    "${fetch.tachyon}/patches/0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-.patch"
    "${fetch.tachyon}/patches/0169-mm-mincore-improve-performance-by-adding-an-unlikely.patch"
    "${fetch.tachyon}/patches/0170-sched-Add-unlikey-branch-hints-to-several-system-cal.patch"
    "${fetch.tachyon}/patches/0171-kcmp-improve-performance-adding-an-unlikely-hint-to-.patch"
    "${fetch.tachyon}/patches/0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-.patch"
    "${fetch.tachyon}/patches/0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127.patch"
    "${fetch.tachyon}/patches/0175-readdir-add-unlikely-hint-on-len-check.patch"
    "${fetch.tachyon}/patches/better_idle_balance.patch"
    "${fetch.tachyon}/patches/epp-retune.patch"
    "${fetch.tachyon}/patches/libsgrowdown.patch"
    "${fetch.tachyon}/patches/mmput_async.patch"
    "${fetch.tachyon}/patches/netscale.patch"
    "${fetch.tachyon}/patches/nonapi-realtek.patch"
    "${fetch.tachyon}/patches/posted_msi.patch"
    "${fetch.tachyon}/patches/ratelimit-sched-yield.patch"
    "${fetch.tachyon}/patches/revert-regression.patch"
    "${fetch.tachyon}/patches/scale.patch"
    "${fetch.tachyon}/patches/scale-net-alloc.patch"
    "${fetch.tachyon}/patches/slack.patch"
  ]
  ++ (lib.optional (host != "v7w7r-youyeetoox1") [
    "${fetch.patches}/${majorMinor}/sched/0001-bore-cachy.patch"
    "${fetch.patches}/${majorMinor}/0009-sched-ext.patch"
  ])
  ++ (lib.optional (host == "v7w7r-youyeetoox1") [
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0003-glitched-eevdf-additions.patch"
  ])
  ++ (lib.optional (host == "v7w7r-macmini81") [
    "${fetch.patches}/${majorMinor}/0010-t2.patch"
  ])
  ++ (lib.optional (host == "v7w7r-macmini81" || host == "v7w7r-rc71l") [
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0003-glitched-base.patch"
    "${fetch.tachyon}/patches/0001-sched-migrate.patch"
  ])
  ++ (lib.optional (host == "v7w7r-higole" || host == "v7w7r-rc71l") [
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0002-clear-patches.patch"
  ])
  ++ (lib.optional hardened [
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0012-linux-hardened.patch"
  ])
  ++ (
    if (host == "v7w7r-rc71l") then
      (
        [
          "${fetch.patches}/${majorMinor}/misc/0001-acpi-call.patch"
          "${fetch.patches}/${majorMinor}/misc/0001-handheld.patch"
          "${fetch.patches}/${majorMinor}/0001-amd-pstate.patch"
          "${fetch.patches}/${majorMinor}/0002-asus.patch"
          "${fetch.patches}/${majorMinor}/0007-hdmi.patch"
          "${fetch.tachyon}/patches/0158-clocksource-only-perform-extended-clocksource-checks.patch"
        ]
        ++ builtins.map (p: "${fetch.asus.outPath}/${p}") [
          "0001-bluetooth-btus-add-new-vid-pid.patch"
          "0002-platform-x86-asus-armoury-add-keyboard-control-firmw.patch"
          "0040-workaround_hardware_decoding_amdgpu.patch"
          "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch"
          "0081-amdgpu-adjust_plane_init_off_by_one.patch"
          "asus-patch-series.patch"
          "PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch"
          "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co.patch"
        ]
      )
    else
      [
        "${fetch.patches}/${majorMinor}/0008-intel-pstate.patch"
        "${fetch.tachyon}/patches/0103-silence-rapl.patch"
        "${fetch.tachyon}/patches/0128-itmt_epb-use-epb-to-scale-itmt.patch"
        "${fetch.tachyon}/patches/0163-thermal-intel-powerclamp-check-MWAIT-first-use-pr_wa.patch"
        "${fetch.tachyon}/patches/vmidle.patch"
      ]
  );
in
pkgs.stdenv.mkDerivation (attrs: {
  inherit patches;
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";

  LLVM = "1";
  stdenv = helpers.stdenvLLVM;
  nativeBuildInputs =
    with pkgs;
    linux_6_18.nativeBuildInputs
    ++ linux_6_18.buildInputs
    ++ [
      clang_18
      llvm_18
      lld_18
    ];

  installPhase = ''
    runHook preInstall
    cp .config $out
    runHook postInstall
  '';

  buildPhase = ''
    runHook preBuild
    cp "${fetch.kConfig}" ".config"

    ${((import ./modules) { inherit host; })}

    make $makeFlags olddefconfig
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags olddefconfig

    runHook postBuild
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [ "x86_64-linux" ];
  };

  passthru = {
    version = kernelData.linux.version;
    inherit localVer patches;
  };
})
