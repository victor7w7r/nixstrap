{
  host,
  inputs,
  lib,
  pkgs,
  kernels,
  hardened ? false,
  ...
}:
let
  fetch = pkgs.callPackage ./fetch.nix { inherit hardened kernels; };
  config = import ./config { inherit host hardened; };

  majorMinor = lib.versions.majorMinor (
    if hardened then kernels.hardened.linux.version else kernels.lts.linux.version
  );

  commonDb = ./config/mod-common.db;
  modprobedDb =
    if host == "v7w7r-macmini81" then
      ./config/mod-macmini.db
    else if host == "v7w7r-youyeetoox1" then
      ./config/mod-server.db
    else if host == "v7w7r-rc71l" then
      ./config/mod-rc71l.db
    else
      ./config/mod-rc71l.db;

  nativeHost =
    if host == "v7w7r-macmini81" then
      "-i7-8700B"
    else if host == "v7w7r-youyeetoox1" then
      "-server-N5105"
    else if host == "v7w7r-rc71l" then
      "-handheld-Ryzen-Z1"
    else
      "-v2";

  localVer = "-v7w7r${nativeHost}${if hardened then "-hardened" else ""}${
    if host == "v7w7r-youyeetoox1" || host == "v7w7r-macmini81" then "-zfs" else ""
  }";

  patches =
    let
      rmRandstruct = with lib; filter (p: !hasInfix "randstruct" p);
    in
    (rmRandstruct kernels.common.config.patches)
    ++ [
      "${fetch.cachy-patches}/${majorMinor}/all/0001-cachyos-base-all.patch"
    ]
    ++ (lib.optional (host != "v7w7r-youyeetoox1") [
      "${fetch.cachy-patches}/${majorMinor}/sched/0001-bore-cachy.patch"
      "${fetch.cachy-patches}/${majorMinor}/sched/0001-sched-ext.patch"
    ])
    ++ (lib.optional hardened [
      "${fetch.cachy-patches}/${majorMinor}/misc/0001-hardened.patch"
    ])
    ++ (lib.optional (host == "v7w7r-rc71l") (
      [
        "${fetch.cachy-patches}/${majorMinor}/misc/0001-acpi-call.patch"
        "${fetch.cachy-patches}/${majorMinor}/misc/0001-handheld.patch"
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
    ));
in
pkgs.stdenv.mkDerivation (attrs: {
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";
  nativeBuildInputs = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto.kernel.nativeBuildInputs;

  postPhase = "${attrs.passthru.extraVerPatch}";

  makeFlags = import "${inputs.nixpkgs}/pkgs/os-specific/linux/kernel/common-flags.nix" {
    inherit lib;
    stdenv = pkgs.stdenv;
    buildPackages = pkgs.buildPackages;
  };

  installPhase = ''
    runHook preInstall
    cp .config $out
    runHook postInstall
  '';

  #

  buildPhase = ''
    runHook preBuild
    cp "${fetch.kernel-config}" ".config"

    export LSMOD=$(mktemp)
    cat "${commonDb}" "${modprobedDb}" | sort > $LSMOD
    cat $LSMOD

    (yes "" | make LSMOD=$LSMOD localmodconfig) || true
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
    inherit localVer;
    version = if hardened then kernels.hardened.linux.version else kernels.lts.linux.version;
    extraVerPatch = ''
      sed -Ei"" 's/EXTRAVERSION = ?(.*)$/EXTRAVERSION = \1${localVer}/g' Makefile
    '';
  };
})
