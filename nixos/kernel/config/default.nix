{ host }:
[
  "CACHY=y"
  "MQ_IOSCHED_ADIOS=y"
  "CC_OPTIMIZE_FOR_PERFORMANCE=n"
  "CC_OPTIMIZE_FOR_PERFORMANCE_O3=y"
  "LOCALVERSION_AUTO=n"
  "TRANSPARENT_HUGEPAGE_MADVISE=n"
  "TRANSPARENT_HUGEPAGE_ALWAYS=y"
  "OVERLAY_FS=m"
  "OVERLAY_FS_REDIRECT_DIR=n"
  "OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y"
  "OVERLAY_FS_INDEX=n"
  "OVERLAY_FS_XINO_AUTO=n"
  "OVERLAY_FS_METACOPY=n"
  "OVERLAY_FS_DEBUG=n"
  "LLVM=y"
  "LLVM_IAS=y"
  "LTO_NONE=n"
  "LTO_CLANG_THIN=y"
  "LTO_CLANG_FULL=n"
  "NR_CPUS=320"
  "NTSYNC=m"

  "CONFIG_AUTOFS4_FS=y"
  "CONFIG_AUTOFS_FS=y"

  "PREEMPT_VOLUNTARY=n"
  "PREEMPT_LAZY=n"

  "LRU_GEN=y"
  "LRU_GEN_ENABLED=y"
  "LRU_GEN_STATS=n"

  "PER_VMA_LOCK=y"
  "PER_VMA_LOCK_STATS=n"

  "DEBUG_INFO=n"
  "DEBUG_INFO_BTF=n"
  "DEBUG_INFO_DWARF4=n"
  "DEBUG_INFO_DWARF5=n"
  "PAHOLE_HAS_SPLIT_BTF=n"
  "DEBUG_INFO_BTF_MODULES=n"
  "SLUB_DEBUG=n"
  "PM_DEBUG=n"
  "PM_ADVANCED_DEBUG=n"
  "PM_SLEEP_DEBUG=n"
  "ACPI_DEBUG=n"
  "SCHED_DEBUG=n"
  "LATENCYTOP=n"
  "DEBUG_PREEMPT=n"

  "BLK_DEV_NVME=y"
  "NLS=m"
  "NLS_UTF8=m"

  "VIRTIO=m"
  "VIRTIO_PCI=m"
  "VIRTIO_BLK=m"
  "VIRTIO_NET=m"

  "HZ_PERIODIC=n"
  "NO_HZ_COMMON=y"
  "NO_HZ=y"
]
++ (
  if host == "v7w7r-rc71l" then
    [
      "ASUS_ARMOURY=m"
      "AMD_PRIVATE_COLOR=y"
      "AMD_3D_VCACHE=m"
      "V4L2_LOOPBACK=m"
      "VHBA=m"
      "DRM_APPLETBDRM=m"
      "HID_APPLETB_BL=m"
      "HID_APPLETB_KBD=m"
      "# CONTEXT_TRACKING_FORCE is not set"
    ]
  else
    [ ]
)
++ (
  if host == "v7w7r-higole" || host == "v7w7r-youyeetoox1" then
    [
      "CONFIG_DEFAULT_FQ_CODEL=n"
      "CONFIG_DEFAULT_FQ=y"
      "DEFAULT_BBR=y"
      "DEFAULT_CUBIC=n"
      "DEFAULT_TCP_CONG=bbr"
      "NET_SCH_FQ_CODEL=m"
      "NET_SCH_FQ=y"
      "TCP_CONG_BBR=y"
      "TCP_CONG_CUBIC=m"
    ]
  else
    [ ]
)
++ (
  if host == "v7w7r-higole" then
    [
      "GENERIC_CPU=y"
      "MZEN4=n"
      "X86_NATIVE_CPU=n"
      "X86_64_VERSION=2"
    ]
  else
    [
      "GENERIC_CPU=n"
      "X86_NATIVE_CPU=y"
    ]
)
++ (
  if host == "v7w7r-youyeetoox1" then
    [
      "CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=n"
      "CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y"

      "PREEMPT_DYNAMIC=n"
      "PREEMPT=n"
      "PREEMPT_NONE=y"

      "HZ=300"
      "NO_HZ_IDLE=y"
      "NO_HZ_FULL=n"
    ]
  else
    [
      "SCHED_BORE=y"

      "PREEMPT_DYNAMIC=y"
      "PREEMPT=y"
      "PREEMPT_NONE=n"

      "CONTEXT_TRACKING_FORCE=n"
      "CONTEXT_TRACKING=y"
      "NO_HZ_FULL_NODEF=y"
      "NO_HZ_FULL=y"
    ]
)
