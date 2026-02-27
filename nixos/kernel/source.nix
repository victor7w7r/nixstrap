{
  host,
  lib,
  pkgs,
  kernelConfig,
  hardened ? false,
  ...
}:
let
  baseKernel =
    if hardened then
      pkgs.linuxPackages_6_17_hardened.override {
        argsOverride = rec {
          src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "sha256-EWgC3DrRZGFjzG/+m926JKgGm1aRNewFI815kGTy7bk=";
          };
          version = "6.17.13";
          modDirVersion = "6.17.13";
        };
      }
    else
      pkgs.linux_6_18;

  majorMinor =
    with lib;
    let
      parts = versions.splitVersion baseKernel.version;
    in
    "${elemAt parts 0}.${elemAt parts 1}";

  patchesSrc = pkgs.callPackage ./patches.nix { inherit host; };
  config = import ./config { inherit host; };

  commonDb = ./config/mod-common.db;
  modprobedDb =
    if host == "v7w7r-macmini81" then
      ./config/mod-macmini.db
    else if host == "v7w7r-youyeetoox1" then
      ./config/mod-server.db
    else if host == "v7w7r-rc71l" then
      ./config/mod-rc71l.db
    else
      commonDb;

in
{
  version = baseKernel.version;
  src = pkgs.stdenv.mkDerivation {
    name = "linux-${majorMinor}-src";
    inherit (baseKernel) version src;

    nativeBuildInputs = with pkgs; [
      bc
      bison
      elfutils
      flex
      gnumake
      gcc
      lz4
      openssl
      perl
      pkg-config
      zstd
    ];

    installPhase = "cp -r . $out";
    env.NIX_ENFORCE_NO_NATIVE = "0";
    buildPhase = ''
      #modprobed-db && e ~/.config/modprobed-db.conf && modprobed-db store && modprobed-db list
      runHook preBuild

      cp "${kernelConfig.config}" ".config"

      export LSMOD=$(mktemp)
      awk '{ print $1, 0, 0 }' ${modprobedDb} ${commonDb} > $LSMOD
      (yes "" | make localmodconfig) || true

      make olddefconfig
      patchShebangs scripts/config
      scripts/config ${lib.concatStringsSep " " config}
      make olddefconfig
      make -j$(nproc) bzImage modules
      runHook postBuild
    '';

    postPatch = ''install -Dm644 "${kernelConfig.kconfig}" arch/x86/configs/cachyos_defconfig'';
    patches =
      (with lib; filter (p: !hasInfix "randstruct" p) baseKernel.patches)
      ++ [ "${patchesSrc.cachy}/${majorMinor}/all/0001-cachyos-base-all.patch" ]
      ++ (lib.optional (host != "v7w7r-youyeetoox1") [
        "${patchesSrc.cachy}/${majorMinor}/sched/0001-bore-cachy.patch"
      ])
      ++ (lib.optional hardened [
        "${patchesSrc.cachy}/${majorMinor}/misc/0001-hardened.patch"
      ])
      ++ (lib.optional (host == "v7w7r-rc71l") (
        [
          "${patchesSrc.cachy}/${majorMinor}/misc/0001-acpi-call.patch"
          "${patchesSrc.cachy}/${majorMinor}/misc/0001-handheld.patch"
        ]
        ++ builtins.map (p: "${patchesSrc.asus.outPath}/${p}") [
          "0001-bluetooth-btus-add-new-vid-pid.patch"
          "0002-platform-x86-asus-armoury-add-keyboard-control-firmw.patch"
          "0004-platform-x86-asus-armoury-add-apu-mem-control-suppor.patch"
          "0005-platform-x86-asus-armoury-add-screen-auto-brightness.patch"
          "0006-platform-x86-asus-wmi-deprecate-bios-features.patch"
          "0007-platform-x86-asus-wmi-rename-ASUS_WMI_DEVID_PPT_FPPT.patch"
          "0008-platform-x86-asus-armoury-add-ppt_-and-nv_-tuning-kn.patch"
          "0010-platform-x86-asus-wmi-move-keyboard-control-firmware.patch"
          "0040-workaround_hardware_decoding_amdgpu.patch"
          "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch"
          "0081-amdgpu-adjust_plane_init_off_by_one.patch"
          "0084-enable-steam-deck-hdr.patch"
          "asus-patch-series.patch"
          "PATCH-v4-1-3-platform-x86-asus-wmi-explicitly-mark-more-code-with-CONFIG_ASUS_WMI_DEPRECATED_ATTRS.patch"
          "PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch"
          "PATCH-v11-00-11-HID-asus-Fix-ASUS-ROG-Laptop-s-Keyboard-backlight-handling.patch"
          "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co.patch"
        ]
      ));
  };
}
