{ host, hardened }:
[
  "-e MQ_IOSCHED_ADIOS"
  "-d CC_OPTIMIZE_FOR_PERFORMANCE"
  "-e CC_OPTIMIZE_FOR_PERFORMANCE_O3"
  "-d LOCALVERSION_AUTO"
  "-m OVERLAY_FS"
  "-d OVERLAY_FS_REDIRECT_DIR"
  "-e OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW"
  "-d OVERLAY_FS_INDEX"
  "-d OVERLAY_FS_XINO_AUTO"
  "-d OVERLAY_FS_METACOPY"
  "-d OVERLAY_FS_DEBUG"
  "-e LLVM"
  "-e LLVM_IAS"
  "-d LTO_NONE"
  "-e LTO_CLANG_THIN"
  "-d LTO_CLANG_FULL"
  "--set-val NR_CPUS 320"
  "-d CONFIG_SECURITY_TOMOYO"

  "-m TCP_CONG_CUBIC"
  "-d DEFAULT_CUBIC"
  "-e TCP_CONG_BBR"
  "-e DEFAULT_BBR"
  "--set-str DEFAULT_TCP_CONG bbr"
  "-m NET_SCH_FQ_CODEL"
  "-e NET_SCH_FQ"
  "-d DEFAULT_FQ_CODEL"
  "-e DEFAULT_FQ"
  "--set-str DEFAULT_NET_SCH fq"

  "-e AUTOFS4_FS"
  "-e AUTOFS_FS"

  "-d PREEMPT_VOLUNTARY"
  "-d PREEMPT_LAZY"

  "-e LRU_GEN"
  "-e LRU_GEN_ENABLED"
  "-d LRU_GEN_STATS"

  "-e PER_VMA_LOCK"
  "-d PER_VMA_LOCK_STATS"

  "-d PAHOLE_HAS_SPLIT_BTF"
  "-d SLUB_DEBUG"
  "-d PM_DEBUG"
  "-d PM_ADVANCED_DEBUG"
  "-d PM_SLEEP_DEBUG"
  "-d ACPI_DEBUG"
  "-d SCHED_DEBUG"
  "-d LATENCYTOP"
  "-d DEBUG_PREEMPT"

  "-e BLK_DEV_NVME"
  "-m NLS"
  "-m NLS_UTF8"

  "-m VIRTIO"
  "-m VIRTIO_PCI"
  "-m VIRTIO_BLK"
  "-m VIRTIO_NET"

  "-d HZ_PERIODIC"
  "-e NO_HZ_COMMON"
  "-e NO_HZ"
]
++ (
  if host == "v7w7r-rc71l" then
    [
      "-m ASUS_ARMOURY"
      "-e AMD_PRIVATE_COLOR"
      "-m AMD_3D_VCACHE"
      "-m V4L2_LOOPBACK"
      "-m VHBA"
      "-m DRM_APPLETBDRM"
      "-m HID_APPLETB_BL"
      "-m HID_APPLETB_KBD"
      #"--unset CONTEXT_TRACKING_FORCE"
    ]
  else
    [ ]
)
++ (
  if !hardened then
    [
      "-e SCHED_CLASS_EXT"
    ]
  else
    [ ]
)
++ (
  if host == "v7w7r-higole" then
    [
      "-e GENERIC_CPU"
      "-d MZEN4"
      "-d X86_NATIVE_CPU"
      "--set-val X86_64_VERSION 2"
    ]
  else
    [
      "-d GENERIC_CPU"
      "-e X86_NATIVE_CPU"
    ]
)
++ (
  if host == "v7w7r-youyeetoox1" then
    [
      "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
      "-e CPU_FREQ_DEFAULT_GOV_PERFORMANCE"

      "-e PREEMPT_NONE_BUILD"
      "-e PREEMPT_NONE"
      "-d PREEMPT"
      "-d PREEMPTION"
      "-d PREEMPT_DYNAMIC"

      "-d TRANSPARENT_HUGEPAGE_ALWAYS"
      "-e TRANSPARENT_HUGEPAGE_MADVISE"

      "-e HZ_300"
      "--set-val HZ 300"
      "-e NO_HZ_IDLE"
      "-d NO_HZ_FULL"
    ]
  else
    [
      "-e CACHY"
      "-m NTSYNC"
      "-e SCHED_BORE"

      "-d TRANSPARENT_HUGEPAGE_MADVISE"
      "-e TRANSPARENT_HUGEPAGE_ALWAYS"

      "-d PREEMPT_NONE"
      "-e PREEMPT_BUILD"
      "-e PREEMPT_DYNAMIC"
      "-e PREEMPT"
      "-e PREEMPT_COUNT"
      "-e PREEMPTION"

      "--set-val HZ 500"
      "-d CONTEXT_TRACKING_FORCE"
      "-e CONTEXT_TRACKING"
      "-e HZ_500"
      "-d HZ_300"
      "-d NO_HZ_IDLE"
      "-e NO_HZ_FULL_NODEF"
      "-e NO_HZ_FULL"
    ]
)
