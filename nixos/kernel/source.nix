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
in
{
  version = baseKernel.version;
  src = pkgs.stdenv.mkDerivation {
    name = "linux-${majorMinor}-src";
    inherit (baseKernel) version src;

    installPhase = "cp -r . $out";
    dontBuild = true;

    postPatch = ''
      install -Dm644 "${kernelConfig.kconfig}" arch/x86/configs/cachyos_defconfig
      patchShebangs scripts/config
    '';

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
          "0040-workaround_hardware_decoding_amdgpu.patch"
          "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch"
          "0081-amdgpu-adjust_plane_init_off_by_one.patch"
          "asus-patch-series.patch"
          "PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch"
          "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co.patch"
        ]
      ));
  };
}
