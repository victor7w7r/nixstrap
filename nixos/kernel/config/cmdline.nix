{ host }:
let
  red = "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166";
  green = "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173";
  blue = "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200";
  opt = "pti=on page_alloc.shuffle=1 elevator=none";
  sec = "page_poison=1 oops=panic randomize_kstack_offset=on";
  vm = "iommu=pt pcie_acs_override=downstream,multifunction kvm.ignore_msrs=1 kvm.report_ignored_msrs=0";
  save = "rcutree.enable_rcu_lazy=1 rcupdate.rcu_expedited=1 threadirqs";
  perf = "split_lock_detect=off tsc=reliable nowatchdog nmi_watchdog=0";
  rescue = "sysrq_always_enabled=0 udev.log_level=3 verbose=1";
  sata =
    if host == "v7w7r-youyeetoox1" || host == "v7w7r-macmini81" then
      "libahci.ignore_sss=1 ahci.mobile_lpm_policy=2"
    else
      "";
  amd =
    if host == "v7w7r-rc71l" then
      "mitigations=off nospectre_v1 nospectre_v2 spec_store_bypass_disable=off "
      + "amd_iommu=on amdgpu.sg_display=0"
    else
      "";
  intel =
    if host != "v7w7r-rc71l" then
      "i915.enable_guc=2 kvm_intel.emulate_invalid_guest_state=0 kvm_intel.nested=1 "
      + "intel_pstate=active intel_iommu=on pcie_ports=compat"
    else
      "";
  higole =
    if host == "v7w7r-higole" then
      "fbcon=rotate:1 usbcore.autosuspend=1 snd_hda_intel.power_save=1 "
      + "i915.enable_psr=0 acpi_backlight=vendor mem_sleep_default=deep "
      + "i2c_dw.disable_fast_mode=1 i915.enable_dpcd_backlight=1"
    else
      "";
  cmd = "${red} ${green} ${blue} ${opt} ${sec} ${vm} ${save} ${amd} ${perf} ${sata} ${rescue} ${intel} ${higole}";
in
[
  "-e CMDLINE_BOOL"
  "-d CMDLINE_OVERRIDE"
  ''--set-str CMDLINE "${cmd}"''
]
