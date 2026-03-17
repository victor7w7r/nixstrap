{
  host,
  lib,
  pkgs,
  helpers,
  linux_6_18,
  kernelData,
  hardened ? false,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux.version;

  fetch = pkgs.callPackage ./fetch.nix {
    inherit kernelData majorMinor hardened;
  };
  config = import ./config { inherit host; };

  nativeHost =
    if host == "v7w7r-macmini81" then
      "-t2-i7-8700B"
    else if host == "v7w7r-youyeetoox1" then
      "-server-N5105"
    else if host == "v7w7r-rc71l" then
      "-handheld-RyzenZ1"
    else
      "-N5095";

  localVer = "-v7w7r${nativeHost}${if hardened then "-hardened" else ""}${
    if host == "v7w7r-youyeetoox1" || host == "v7w7r-macmini81" then "-zfs" else ""
  }";

  patches = [
    "${fetch.cachy-patches}/${majorMinor}/0003-bbr3.patch"
    "${fetch.cachy-patches}/${majorMinor}/0004-cachy.patch"
    "${fetch.cachy-patches}/${majorMinor}/0005-crypto.patch"
    "${fetch.cachy-patches}/${majorMinor}/0006-fixes.patch"
  ]
  ++ (lib.optional (host != "v7w7r-youyeetoox1") [
    "${fetch.cachy-patches}/${majorMinor}/sched/0001-bore-cachy.patch"
    "${fetch.cachy-patches}/${majorMinor}/0009-sched-ext.patch"
  ])
  ++ (lib.optional (host == "v7w7r-macmini81") [
    "${fetch.cachy-patches}/${majorMinor}/0010-t2.patch"
  ])
  ++ (lib.optional hardened [ "${fetch.cachy-patches}/${majorMinor}/misc/0001-hardened.patch" ])
  ++ (
    if (host == "v7w7r-rc71l") then
      (
        [
          "${fetch.cachy-patches}/${majorMinor}/misc/0001-acpi-call.patch"
          "${fetch.cachy-patches}/${majorMinor}/misc/0001-handheld.patch"
          "${fetch.cachy-patches}/${majorMinor}/0001-amd-pstate.patch"
          "${fetch.cachy-patches}/${majorMinor}/0002-asus.patch"
          "${fetch.cachy-patches}/${majorMinor}/0007-hdmi.patch"
        ]
        ++ builtins.map (p: "${fetch.asus-patches.outPath}/${p}") [
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
      [ "${fetch.cachy-patches}/${majorMinor}/0008-intel-pstate.patch" ]
  );
in
pkgs.stdenv.mkDerivation (attrs: {
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";

  LLVM = "1";
  LLVM_IAS = "1";

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
    cp "${fetch.kernel-config}" ".config"

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
