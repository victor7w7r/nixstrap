{ lib, host }:
let
  server = host == "v7w7r-youyeetoox1";
  higole = host == "v7w7r-higole";
in
[
  "-e CACHY"
  "-e MQ_IOSCHED_ADIOS"
  "-d CC_OPTIMIZE_FOR_PERFORMANCE"
  "-e CC_OPTIMIZE_FOR_PERFORMANCE_O3"
  "-d LOCALVERSION_AUTO"
  "-d TRANSPARENT_HUGEPAGE_MADVISE"
  "-e TRANSPARENT_HUGEPAGE_ALWAYS"
  "-m OVERLAY_FS"
  "-d OVERLAY_FS_REDIRECT_DIR"
  "-e OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW"
  "-d OVERLAY_FS_INDEX"
  "-d OVERLAY_FS_XINO_AUTO"
  "-d OVERLAY_FS_METACOPY"
  "-d OVERLAY_FS_DEBUG"
  "-d LTO_NONE"
  "-e LTO_CLANG_THIN"
  "-d LTO_CLANG_FULL"
  "--set-val NR_CPUS 320"
  "-m NTSYNC"

  "-d PREEMPT_VOLUNTARY"
  "-d PREEMPT_LAZY"

  "-e LRU_GEN"
  "-e LRU_GEN_ENABLED"
  "-d LRU_GEN_STATS"

  "-e PER_VMA_LOCK"
  "-d PER_VMA_LOCK_STATS"

  "-d DEBUG_INFO"
  "-d DEBUG_INFO_BTF"
  "-d DEBUG_INFO_DWARF4"
  "-d DEBUG_INFO_DWARF5"
  "-d PAHOLE_HAS_SPLIT_BTF"
  "-d DEBUG_INFO_BTF_MODULES"
  "-d SLUB_DEBUG"
  "-d PM_DEBUG"
  "-d PM_ADVANCED_DEBUG"
  "-d PM_SLEEP_DEBUG"
  "-d ACPI_DEBUG"
  "-d SCHED_DEBUG"
  "-d LATENCYTOP"
  "-d DEBUG_PREEMPT"

  "-e NVME_KEYRING"
  "-e NVME_AUTH"
  "-e NVME_CORE"
  "-e BLK_DEV_NVME"
  "-d NVME_TARGET"

  "-d HZ_PERIODIC"
  "-e NO_HZ_COMMON"
  "-e NO_HZ"
]
++ (lib.optional (host == "v7w7r-rc71l") [
  "-m ASUS_ARMOURY"
  "-e AMD_PRIVATE_COLOR"
  "-m AMD_3D_VCACHE"
  "-m V4L2_LOOPBACK"
  "-m VHBA"
  "-m DRM_APPLETBDRM"
  "-m HID_APPLETB_BL"
  "-m HID_APPLETB_KBD"
  "--unset CONTEXT_TRACKING_FORCE"
])
++ (lib.optional (server || higole) [
  "-d CONFIG_DEFAULT_FQ_CODEL"
  "-e CONFIG_DEFAULT_FQ"
  "-e DEFAULT_BBR"
  "-d DEFAULT_CUBIC"
  "--set-str DEFAULT_TCP_CONG bbr"
  "-m NET_SCH_FQ_CODEL"
  "-e NET_SCH_FQ"
  "-e TCP_CONG_BBR"
  "-m TCP_CONG_CUBIC"
])
++ (
  if higole then
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
  if server then
    [
      "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
      "-e CPU_FREQ_DEFAULT_GOV_PERFORMANCE"

      "-d PREEMPT_DYNAMIC"
      "-d PREEMPT"
      "-e PREEMPT_NONE"

      "--set-val HZ 300"
      "-e NO_HZ_IDLE"
      "-d NO_HZ_FULL"
    ]
  else
    [
      "-e SCHED_BORE"

      "-e PREEMPT_DYNAMIC"
      "-e PREEMPT"
      "-d PREEMPT_NONE"

      "-d CONTEXT_TRACKING_FORCE"
      "-e CONTEXT_TRACKING"
      "-e NO_HZ_FULL_NODEF"
      "-e NO_HZ_FULL"
    ]
)
