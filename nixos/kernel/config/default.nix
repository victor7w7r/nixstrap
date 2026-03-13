{ host, hardened }:
[
  "-e MQ_IOSCHED_ADIOS"
  "--set-str DEFAULT_HOSTNAME v7w7r"
  "-d CC_OPTIMIZE_FOR_PERFORMANCE"
  "-e CC_OPTIMIZE_FOR_PERFORMANCE_O3"
  "-d LOCALVERSION_AUTO"
  "-d DRM_XE"
  "-d DRM_XE_DISPLAY"
  "-e LLVM"
  "-e LLVM_IAS"
  "-d LTO_NONE"
  "-e LTO_CLANG_THIN"
  "-d LTO_CLANG_FULL"
  "-d SECURITY_TOMOYO"
  "-d CONFIG_ATA_PIIX"
  "-d CONFIG_PATA_MPIIX"

  "-e NET_VENDOR_AQUANTIA"
  "-e NET_VENDOR_BROADCOM"
  "-e NET_VENDOR_REALTEK"
  "-e NET_VENDOR_MICROSOFT"

  "-m TCP_CONG_CUBIC"
  "-d DEFAULT_CUBIC"
  "-e TCP_CONG_BBR"
  "-e DEFAULT_BBR"
  "--set-str DEFAULT_TCP_CONG bbr"
  "-m NET_SCH_FQ_CODEL"
  "-e NET_SCH_FQ"
  "-d DEFAULT_FQ_CODEL"
  "-e DEFAULT_FQ"
  "-d NUMA"
  "-d XEN"
  "--set-str DEFAULT_NET_SCH fq"

  "-e AUTOFS4_FS"
  "-e AUTOFS_FS"

  "-d PREEMPT_VOLUNTARY"
  "-d PREEMPT_LAZY"

  "-e LRU_GEN"
  "-e LRU_GEN_ENABLED"
  "-d LRU_GEN_STATS"

  "-d CPU_SUP_HYGON"
  "-d CPU_SUP_CENTAUR"
  "-d CPU_SUP_ZHAOXIN"

  "-e PER_VMA_LOCK"
  "-d PER_VMA_LOCK_STATS"

  "-d DEBUG_INFO"
  "-d DEBUG_INFO_BTF"
  "-d DEBUG_INFO_DWARF4"
  "-d DEBUG_INFO_DWARF5"
  "-d PAHOLE_HAS_SPLIT_BTF"
  "-d DEBUG_INFO_BTF_MODULES"
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

  "-d GENERIC_CPU"
  "-e X86_NATIVE_CPU"
]
++ (
  if host == "v7w7r-rc71l" then
    [
      "-m ASUS_ARMOURY"
      "-e CPU_SUP_AMD"
      "-e NET_VENDOR_AMD"
      "-e NET_VENDOR_ASIX"
      "-d CPU_SUP_INTEL"
      "-e AMD_PRIVATE_COLOR"
      "-m AMD_3D_VCACHE"
      "-e KVM_AMD"
      "-m V4L2_LOOPBACK"
      "-m VHBA"
      "-d HAVE_INTEL_TXT"
      "-d X86_INTEL_LPSS"
      "-d INTEL_TDX_GUEST"
      "-d CPU_SUP_INTEL"
      "-d X86_MCE_INTEL"
      "-d PERF_EVENTS_INTEL_RAPL"
      "-d X86_INTEL_MEMORY_PROTECTION_KEYS"
      "-d X86_INTEL_TSX_MODE_AUTO"
      "-d INTEL_TDX_HOST"
      "-d X86_INTEL_PSTATE"
      "-d INTEL_IDLE"
      "-d KVM_INTEL"
      "-d KVM_INTEL_TDX"
      "-d BT_INTEL"
      "-d BT_INTEL_PCIE"
      "-d NET_VENDOR_INTEL"
      "-d WLAN_VENDOR_INTEL"
      "-d PINCTRL_INTEL"
      "-d INTEL_HFI_THERMAL"
      "-d INTEL_SOC_PMIC"
      "-d INTEL_SOC_PMIC_CHTWC"
      "-d INTEL_GTT"
      "-d SND_HDA_INTEL"
      "-d SND_HDA_CODEC_HDMI_INTEL"
      "-d SND_HDA_INTEL_HDMI_SILENT_STREAM"
      "-d SND_INTEL_NHLT"
      "-d SND_INTEL_DSP_CONFIG"
      "-d SND_INTEL_SOUNDWIRE_ACPI"
      "-d SND_SOC_INTEL_SST_TOPLEVEL"
      "-d SND_SOC_ACPI_INTEL_MATCH"
      "-d SND_SOC_ACPI_INTEL_SDCA_QUIRKS"
      "-d SND_SOC_INTEL_MACH"
      "-d SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES"
      "-d SND_SOC_SOF_INTEL_TOPLEVEL"
      "-d SND_SOC_SOF_INTEL_COMMON"
      "-d SND_SOC_SOF_INTEL_SKL"
      "-d INTEL_LDMA"
      "-d INTEL_TURBO_MAX_3"
      "-d INTEL_SCU_IPC"
      "-d INTEL_SCU"
      "-d INTEL_SCU_PCI"
      "-d INTEL_IOMMU"
      "-d INTEL_IOMMU_SVM"
      "-d INTEL_IOMMU_DEFAULT_ON"
      "-d INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON"
      "-d INTEL_IOMMU_PERF_EVENTS"
      #"--unset CONTEXT_TRACKING_FORCE"
    ]
  else
    [
      "-e DRM_I915"
      "-e CPU_SUP_INTEL"
      "-e NET_VENDOR_INTEL"
      "-d KVM_AMD"
      "-d CPU_SUP_AMD"
      "-d AMD_SECURE_AVIC"
      "-d X86_AMD_PLATFORM_DEVICE"
      "-d CPU_SUP_AMD"
      "-d X86_MCE_AMD"
      "-d PERF_EVENTS_AMD_BRS"
      "-d AMD_MEM_ENCRYPT"
      "-d X86_AMD_PSTATE"
      "-d X86_AMD_PSTATE_DEFAULT_MODE"
      "-d AMD_NB"
      "-d AMD_NODE"
      "-d NET_VENDOR_AMD"
      "-d PINCTRL_AMD"
      "-d USB_PCI_AMD"
      "-d AMD_HFI"
      "-d AMD_3D_VCACHE"
      "-d AMD_WBRF"
      "-d AMD_IOMMU"
    ]
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
  if host == "v7w7r-youyeetoox1" then
    [
      "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
      "-e CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
      "--set-val NR_CPUS 8"

      "-e PREEMPT_NONE_BUILD"
      "-e PREEMPT_NONE"
      "-d PREEMPT"
      "-d PREEMPTION"
      "-d PREEMPT_DYNAMIC"

      "-d TRANSPARENT_HUGEPAGE_ALWAYS"
      "-e TRANSPARENT_HUGEPAGE_MADVISE"

      "-d INPUT_JOYSTICK"
      "-d INPUT_TABLET"
      "-d INPUT_TOUCHSCREEN"

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
      "-e PREEMPTION"

      "-d CONTEXT_TRACKING_FORCE"
      "-e CONTEXT_TRACKING"

    ] ++ (
      if host == "v7w7r-higole" then [
        "-e HZ_300"
        "--set-val NR_CPUS 8"
        "--set-val HZ 300"
        "-e NO_HZ_IDLE"
        "-e PREEMPT_VOLUNTARY"
        "-d NO_HZ_FULL"
      ] else [
        "--set-val HZ 1000"
        "--set-val NR_CPUS 32"
        "-e HZ_1000"
        "-d NO_HZ_IDLE"
        "-e NO_HZ_FULL"
        "-e PREEMPT_DYNAMIC"
        "-e NO_HZ_FULL_NODEF"
        "-e RCU_NOCB_CPU"

        "-e PREEMPT"
        "-e PREEMPT_COUNT"
      ]
    )
)
