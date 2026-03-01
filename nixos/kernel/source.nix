{
  host,
  lib,
  pkgs,
  hardened ? false,
  ...
}:
let
  config = import ./config { inherit host; };

  kernelVersion = "6.18.15";
  majorMinor = lib.versions.majorMinor kernelVersion;

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

  fetch = import ./fetch.nix {
    inherit kernelVersion hardened pkgs;
    kernelHash = "sha256-fHFiFsPEE07Q3mkZVwHmd1d7vN05efMxwYKs0Gvy8XA=";
    asusPatchesHash = "sha256-3G/oLfYdL+g+OoacjOuEwFg7/EyLPxKCnlZfHOYWmTk=";
    asusPatchesRev = "0e4aca508d46305a4d3fdf814c5d2bded30a2cdb";
    kernelConfigHash = "sha256-d1GhWEdENpt002r7mmVJ6n4FqJ/W+m8IZJl5ioWDwjo=";
    cachyPatchesHash = "sha256-LhKeRpbG355d/h0H+esisnZ695I7PTFjEkOHKeEtO54=";
  };

  patches = [
    "${fetch.cachy-patches}/${majorMinor}/all/0001-cachyos-base-all.patch"
  ]
  ++ (lib.optional (host != "v7w7r-youyeetoox1") [
    "${fetch.cachy-patches}/${majorMinor}/sched/0001-bore-cachy.patch"
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
pkgs.stdenv.mkDerivation {
  src = fetch.kernel-src;
  name = "linux-${majorMinor}${localVer}";
  nativeBuildInputs = with pkgs; [
    stdenv.cc
    openssl
    binutils
    bison
    flex
    perl
    pkg-config
    elfutils
    gnumake
    libelf
    ncurses
  ];
  installPhase = ''
    cp .config $out
    exit 0
  '';

  buildPhase = ''
    #modprobed-db && e ~/.config/modprobed-db.conf && modprobed-db store && modprobed-db list
    cp "${fetch.kernel-config}" ".config"

    export LSMOD=$(mktemp)
    cat "${commonDb}" "${modprobedDb}" | sort > $LSMOD
    cat $LSMOD
    (yes "" | make localmodconfig) || true

    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make olddefconfig
  '';

  passthru = {
    version = kernelVersion;
    inherit localVer;
    kernelPatches = patches;
    #extraVerPatch = ''sed -Ei"" 's/EXTRAVERSION = ?(.*)$/EXTRAVERSION = \1${versions.suffix}/g' Makefile'';
  };

}
