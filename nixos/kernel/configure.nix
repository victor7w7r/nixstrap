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
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0006-add-acs-overrides_iommu.patch"
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch"
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0003-glitched-cfs.patch"
    "${fetch.tkg}/linux-tkg-patches/${majorMinor}/0013-optimize_harder_O3.patch"
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
      [ "${fetch.patches}/${majorMinor}/0008-intel-pstate.patch" ]
  );
in
pkgs.stdenv.mkDerivation (attrs: {
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
    kernelPatches = patches;
    version = kernelData.linux.version;
    inherit localVer;
  };
})
