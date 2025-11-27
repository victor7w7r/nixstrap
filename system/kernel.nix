{
  lib,
  pkgs,
  ...
}:

{

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
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
      systemd = {
        enable = true;
        packages = with pkgs; [
          cryptsetup
          lvm2
          e2fsprogs
          bash
          busybox
          coreutils
        ];
      };
    };
    kernelParams = [
      "lsm=landlock,yama,integrity,apparmor,bpf"
      "rw"
      "add_efi_memmap"
      "root=/dev/mapper/vg0-fstemp"
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
    ];
  };

  #system.boot.loader.ukiFile = "nixos.efi";
  #system.build.uki = ukiGen;
  #systemd.unit=multi-user.target
  #environment.etc."kernel/uki.conf".source = ./files/uki.conf;

}
