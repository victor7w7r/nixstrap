{
  host,
  lib,
  pkgs,
  helpers,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux.version;
  hardened = host == "v7w7r-youyeetoox1";
  config = import ./config { inherit host; };

  specialization =
    {
      middle ? "",
    }:
    if host == "v7w7r-macmini81" then
      "-t2${middle}"
    else if host == "v7w7r-youyeetoox1" then
      "-server${middle}"
    else if host == "v7w7r-rc71l" then
      "-handheld${middle}"
    else if host == "v7w7r-higole" then
      "-lowperf${middle}"
    else
      "";

  fetch = pkgs.callPackage ./fetch.nix {
    inherit kernelData majorMinor hardened;
  };
  localVer = "-v7w7r${specialization { middle = if hardened then "-hardened" else ""; }}-native";

  patches =
    (lib.optional (
      host != "v7w7r-youyeetoox1"
    ) "${fetch.patches}/${majorMinor}/sched/0001-bore-cachy.patch")
    ++ (lib.optional hardened "${fetch.patches}/${majorMinor}/misc/0001-hardened.patch")
    ++ (lib.optional (host == "v7w7r-rc71l") [
      "${fetch.patches}/${majorMinor}/misc/0001-acpi-call.patch"
      "${fetch.patches}/${majorMinor}/misc/0001-handheld.patch"
    ])
    ++ [
      "${fetch.patches}/${majorMinor}/misc/0001-clang-polly.patch"
      "${fetch.patches}/${majorMinor}/misc/dkms-clang.patch"
      "${fetch.patches}/${majorMinor}/misc/poc-selector.patch"
      "${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
      "${fetch.patches}/${majorMinor}/misc/nap-governor.patch"

      #"${fetch.tachyon}/patches/0001-add-umonitor-umwait-C0.x-C-states.patch"
      #"${fetch.tachyon}/patches/0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an.patch"
      #"${fetch.tachyon}/patches/0002-mm-disable-proactive-compaction-by-de.patch"
      #"${fetch.tachyon}/patches/0002-sched-core-add-some-branch-hints-based-on-gcov-analy.patch"
      "${fetch.tachyon}/patches/0003-mm-stop-kswapd-early-when-nothings-wa.patch"
      #"${fetch.tachyon}/patches/0005-mm-increment-kswapd_waiters-for-throt.patch" #ERROR
      "${fetch.tachyon}/patches/0104-pci-pme-wakeups.patch"
      #"${fetch.tachyon}/patches/0107-bootstats-add-printk-s-to-measure-boot-time-in-more-.patch"
      "${fetch.tachyon}/patches/0108-smpboot-reuse-timer-calibration.patch"
      #"${fetch.tachyon}/patches/0110-give-rdrand-some-credit.patch"
      "${fetch.tachyon}/patches/0111-ipv4-tcp-allow-the-memory-tuning-for-tcp-to-go-a-lit.patch"
      "${fetch.tachyon}/patches/0112-init-wait-for-partition-and-retry-scan.patch"
      "${fetch.tachyon}/patches/0113-print-fsync-count-for-bootchart.patch"
      "${fetch.tachyon}/patches/0114-add-boot-option-to-allow-unsigned-modules.patch"
      "${fetch.tachyon}/patches/0115-enable-stateless-firmware-loading.patch"
      "${fetch.tachyon}/patches/0116-migrate-some-systemd-defaults-to-the-kernel-defaults.patch"
      "${fetch.tachyon}/patches/0117-xattr-allow-setting-user.-attributes-on-symlinks-by-.patch"
      #"${fetch.tachyon}/patches/0118-add-scheduler-turbo3-patch.patch"
      "${fetch.tachyon}/patches/0120-do-accept-in-LIFO-order-for-cache-efficiency.patch"
      "${fetch.tachyon}/patches/0122-ata-libahci-ignore-staggered-spin-up.patch"
      "${fetch.tachyon}/patches/0125-nvme-workaround.patch"
      "${fetch.tachyon}/patches/0127-lib-raid6-add-patch.patch"
      #"${fetch.tachyon}/patches/0129-mm-wakeups-remove-a-wakeup.patch"
      "${fetch.tachyon}/patches/0131-add-a-per-cpu-minimum-high-watermark-an-tune-batch-s.patch"
      #"${fetch.tachyon}/patches/0132-prezero-20220308.patch"
      "${fetch.tachyon}/patches/0135-initcall-only-print-non-zero-initcall-debug-to-speed.patch"
      "${fetch.tachyon}/patches/0136-crypto-kdf-make-the-module-init-call-a-late-init-cal.patch"
      "${fetch.tachyon}/patches/0161-ACPI-align-slab-buffers-for-improved-memory-performa.patch"
      #"${fetch.tachyon}/patches/0162-extra-optmization-flags.patch"
      "${fetch.tachyon}/patches/0166-sched-fair-remove-upper-limit-on-cpu-number.patch"
      "${fetch.tachyon}/patches/0167-net-sock-increase-default-number-of-_SK_MEM_PACKETS-.patch"
      "${fetch.tachyon}/patches/0173-cpuidle-psd-add-power-sleep-demotion-prevention-for-.patch"
      "${fetch.tachyon}/patches/0174-memcg-increase-MEMCG_CHARGE_BATCH-to-127.patch"
      "${fetch.tachyon}/patches/0175-readdir-add-unlikely-hint-on-len-check.patch"
      "${fetch.tachyon}/patches/better_idle_balance.patch"
      "${fetch.tachyon}/patches/epp-retune.patch"
      "${fetch.tachyon}/patches/libsgrowdown.patch"
      "${fetch.tachyon}/patches/mmput_async.patch"
      #"${fetch.tachyon}/patches/netscale.patch"
      "${fetch.tachyon}/patches/posted_msi.patch"
      "${fetch.tachyon}/patches/ratelimit-sched-yield.patch"
      #"${fetch.tachyon}/patches/revert-regression.patch"
      #"${fetch.tachyon}/patches/scale.patch"
      "${fetch.tachyon}/patches/scale-net-alloc.patch"
      "${fetch.tachyon}/patches/slack.patch"
    ]
    ++ (
      if (host == "v7w7r-rc71l") then
        (
          [
            "${fetch.tachyon}/patches/0158-clocksource-only-perform-extended-clocksource-checks.patch"
          ]
          ++ map (p: "${fetch.asus.outPath}/${p}") [
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
          "${fetch.tachyon}/patches/0128-itmt_epb-use-epb-to-scale-itmt.patch"
        ]
    );
in
pkgs.stdenv.mkDerivation (attrs: rec {
  inherit patches;
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";
  LLVM = "1";
  stdenv = helpers.stdenvLLVM;
  /*
    pkgs.ccacheStdenv.override {
     stdenv = helpers.stdenvLLVM;
     };
  */

  nativeBuildInputs =
    with pkgs;
    kernel.nativeBuildInputs
    ++ kernel.buildInputs
    ++ [
      clang_20
      llvm_20
      lld_20
    ];

  installPhase = "cp .config $out";

  buildPhase = ''
    cp "${fetch.kConfig}" ".config"

    ${((import ./modules) { inherit host; })}
    make $makeFlags olddefconfig
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags olddefconfig
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [ "x86_64-linux" ];
  };

  passthru = {
    version = kernelData.linux.version;
    inherit localVer patches;
  };
})
