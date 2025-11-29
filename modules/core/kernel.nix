{ config, lib, pkgs, ... }:

{
  console = {
    enable = true;
    packages = [ pkgs.spleen ];
    earlySetup = true;
    font = "spleen-8x16";
    keyMap = "us";
  };

  boot = {
    tmp.cleanOnBoot = true;
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      enable = true;
      compressor = "xz";
      compressorArgs = [
        "--check=crc32"
        "--lzma2=dict=6MiB"
        "-T0"
      ];
      availableKernelModules = [
        "i915"
        "ext4"
      ];
      kernelModules = [ "i915" ];
      services.lvm.enable = true;
      #extraFiles."/syskey.key".source = "/run/secrets/syskey.key";
      #"/extkey.key" = "/run/secrets/extkey.key";
      secrets = {
        #"/extkey.key" = /run/secrets/extkey.key;
        #"/syskey.key" = null;
      };
      luks.devices = {
        system = {
          device = "/dev/disk/by-label/SYSTEM";
          #keyFile = "/syskey.key";
          allowDiscards = true;
          preLVM = true;
        };
        #storage = {
        #  device = "/dev/disk/by-label/STORAGE";
        #  keyFile = "/extkey.key";
        #  preLVM = true;
        #};
      };
      systemd = {
        enable = true;
        emergencyAccess = true;
        extraBin = {
          bash = "${pkgs.bash}/bin/bash";
          find = "${pkgs.findutils}/bin/find";
          coreutils = "${pkgs.coreutils-full}/bin/coreutils";
          grep = "${pkgs.gnugrep}/bin/grep";
          busybox = "${pkgs.busybox}/bin/busybox";
        };
      };
    };
    kernelParams = [
      "lsm=landlock,yama,integrity,apparmor,bpf"
      "rw"
      "add_efi_memmap"
      "root=${config.setupDisks.mockdisk}"
      "rootfstype=ext4"
      "rootflags=noatime,lazytime,nobarrier,nodiscard,commit=120"
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
      "loglevel=3"
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
      "nowatchdog"
      "mitigations=off"
      "rcutree.enable_rcu_lazy=1"
      "rcupdate.rcu_expedited=1"
      "libahci.ignore_sss=1"
      "nospectre_v1"
      "nospectre_v2"
      "spec_store_bypass_disable=off"
      "page_alloc.shuffle=1"
      "tsc=reliable"
      "srbds=off"
      "kvm.ignore_msrs=1"
      "kvm.nx_huge_pages=off"
      "kvm.report_ignored_msrs=0"
      "kvm_intel.emulate_invalid_guest_state=0"
      "kvm_intel.nested=1"
      #"kvmfr.static_size_mb=128"
      #systemd.unit=multi-user.target single
    ];
  };

  system.activationScripts.installUKI = {
    text = ''
      set -euo pipefail

      if [ -L /run/current-system ]; then
        TOPLEVEL=$(readlink -f /run/current-system)
      else
        TOPLEVEL=$(readlink -f /nix/var/nix/profiles/system)
      fi

      ${pkgs.buildPackages.systemdUkify}/lib/systemd/ukify build \
        --linux="${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}" \
        --initrd="${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" \
        --cmdline="init=$TOPLEVEL/init ${toString config.boot.kernelParams}" \
        --uname="${config.boot.kernelPackages.kernel.modDirVersion}" \
        --os-release="${config.system.build.etc}/etc/os-release" \
        --output=/boot/EFI/Linux/nixos.efi
        #--signtool=systemd-sbsign \
        #--secureboot-private-key /var/lib/sbctl/db/db.key \
        #--secureboot-certificate /var/lib/sbctl/db/db.pem \

      if command -v sbctl >/dev/null 2>&1; then
        sbctl sign /boot/EFI/Linux/nixos.efi || echo "sbctl sign failed"
      fi
    '';
  };

}
