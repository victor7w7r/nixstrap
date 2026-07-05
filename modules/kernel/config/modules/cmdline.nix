{
  # #"systemd.gpt_auto=0" "rootwait"
  kernel.config.modules.cmdline =
    {
      extra ? "",
      isIntel ? false,
      isAmd ? false,
      isSec ? false,
      isSata ? false,
    }:
    let
      red = "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166";
      green = "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173";
      blue = "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200";
      perf = "split_lock_detect=off nowatchdog nmi_watchdog=0 zram.num_devices=2";
      kvm = "kvm.ignore_msrs=1 kvm.report_ignored_msrs=0 ";
      sec = "page_poison=1 oops=panic randomize_kstack_offset=on ";
      amd = "mitigations=off nospectre_v1 nospectre_v2 spec_store_bypass_disable=off amdgpu.sg_display=0 amdgpu.gttsize=8192 amd_iommu=on amd_pstate=passive ";
      sata = "libahci.ignore_sss=1 ahci.mobile_lpm_policy=2 ";
      intel = "iommu=pt i915.enable_guc=2 kvm_intel.nested=1 intel_pstate=passive intel_iommu=on pcie_ports=compat ";
    in
    {
      CMDLINE_BOOL = "y";
      CMDLINE_OVERRIDE = "n";
      CMDLINE =
        "${red} ${green} ${blue} ${perf} ${kvm}"
        + (if isIntel then intel else "")
        + (if isAmd then amd else "")
        + (if isSata then sata else "")
        + (if isSec then sec else "")
        + extra;
    };
}
