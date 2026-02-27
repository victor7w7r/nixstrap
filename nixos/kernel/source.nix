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
      pkg-config
      perl
      zstd
    ];

    installPhase = "cp -r . $out";
    env.NIX_ENFORCE_NO_NATIVE = "0";
    buildPhase = ''
           #modprobed-db && e ~/.config/modprobed-db.conf && modprobed-db store && modprobed-db list
           runHook preBuild
           cp "${kernelConfig.config}" ".config"

           export LSMOD=$(mktemp)
      > LSMOD
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
  };
}
