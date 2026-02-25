{
  host,
  lib,
  pkgs,
  stdenv,
  hardened ? false,
  ...
}:
let
  baseKernel =
    if hardened then
      pkgs.linux.override {
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

  asus = host == "v7w7r-rc71l";
  notServer = host != "v7w7r-youyeetoox1";

  patches = pkgs.callPackage ./patches.nix { };
  fetchCachyPatch =
    patchPath:
    pkgs.runCommand "cachyos-${majorMinor}-${patchPath}" { } ''
      cp "${patches.cachyPatches}/${majorMinor}/${patchPath}" "$out"
    '';
in
{
  inherit baseKernel;
  src = stdenv.mkDerivation {
    inherit (baseKernel) version src;

    pname = "linux-${majorMinor}-src";
    dontConfigure = true;
    installPhase = ''mkdir -pv "$out" && rsync -avhP "./" "$out/"'';

    nativeBuildInputs = with pkgs; [
      rsync
      perl
    ];

    /*
      kernelPatches.bridge_stp_helper.patch
      kernelPatches.request_key_helper.patch
    */
    patches =
      (with lib; filter (p: !hasInfix "randstruct" p) baseKernel.patches)
      ++ (lib.optional notServer [
        (fetchCachyPatch "/sched/0001-bore-cachy.patch")
      ])
      ++ (lib.optional hardened [
        (fetchCachyPatch "/misc/0001-hardened.patch")
      ])
      ++ (lib.optional asus [
        (fetchCachyPatch "/misc/0001-acpi-call.patch")
        (fetchCachyPatch "/misc/0001-handheld.patch")
      ])
      ++ (lib.optional asus (
        builtins.map (p: "${patches.asusPatches.outPath}") [
          "0001-acpi-proc-idle-skip-dummy-wait.patch"
          "0027-mt76_-mt7921_-Disable-powersave-features-by-default.patch"
          "0032-Bluetooth-btusb-Add-a-new-PID-VID-0489-e0f6-for-MT7922.patch"
          "0038-mediatek-pci-reset.patch"
          "0040-workaround_hardware_decoding_amdgpu.patch"
          "v2-0005-platform-x86-asus-wmi-don-t-allow-eGPU-switching-.patch"
          #"0001-HID-asus-fix-more-n-key-report-descriptors-if-n-key-.patch"
          #"0002-HID-asus-make-asus_kbd_init-generic-remove-rog_nkey_.patch"
          #"0002-platform-x86-asus-wmi-don-t-fail-if-platform_profile.patch"
          #"0003-asus-bios-refactor-existing-tunings-in-to-asus-bios-.patch"
          #"0003-HID-asus-add-ROG-Ally-N-Key-ID-and-keycodes.patch"
          #"0003-platform-x86-asus-wmi-add-macros-and-expose-min-max-.patch"
          #"0004-asus-bios-add-panel-hd-control.patch"
          #"0005-asus-wmi-don-t-error-out-if-platform_profile-already.patch"
          #"0006-asus-bios-add-apu-mem.patch"
          #"0007-asus-bios-add-core-count-control.patch"
          #"0035-Add_quirk_for_polling_the_KBD_port.patch"
          #"v2-0001-hid-asus-use-hid-for-brightness-control-on-keyboa.patch"
          #"v4-0004-platform-x86-asus-wmi-support-toggling-POST-sound.patch"
          #"v4-0005-platform-x86-asus-wmi-store-a-min-default-for-ppt.patch"
          #"v4-0006-platform-x86-asus-wmi-adjust-formatting-of-ppt-na.patch"
          #"v4-0007-platform-x86-asus-wmi-ROG-Ally-increase-wait-time.patch"
          #"v4-0008-platform-x86-asus-wmi-Add-support-for-MCU-powersa.patch"
          #"v4-0009-platform-x86-asus-wmi-cleanup-main-struct-to-avoi.patch"
        ]
      ));

    postPatch = ''
      for dir in arch/*/configs; do
        install -Dm644 "${(pkgs.callPackage ./kernel-config.nix { inherit hardened; }).kconfig}" \
        "$dir/cachyos_defconfig"
      done
    '';
  };
}
