{ kernel, lib, ... }: {
  kernel.config.arm = with lib.kernel; {
    apply =
      {
        enable ? true,
        isSunxi ? false,
        isRockchip ? false,
      }:
      with kernel.config.arm;
      lib.mkMerge [
        (include { isDenied = !enable; })
        (lib.optional isSunxi (sunxi { }))
        (lib.optional isRockchip (rockchip { }))
        (lib.optional enable (denied { }))
      ];

    include =
      with kernel.config.utils;
      {
        isDenied ? false,
      }:
      {
        LIBNVDIMM = setupDenial isDenied module;
        SCSI_SAS_LIBSAS = setupDenial isDenied module;
        SCSI_SAS_ATTRS = setupDenial isDenied module;
        SCSI_MPT3SAS = setupDenial isDenied module;
        CRYPTO_SM4_GENERIC = setupDenial isDenied module;
        CRYPTO_SM3 = setupDenial isDenied module;
        CRYPTO_DES = setupDenial isDenied module;
        CRYPTO_MD5 = setupDenial isDenied module;
      };

    sunxi = { }: {
      ARCH_SUNXI = yes;
      ARCH_QCOM = no;
      ARCH_ROCKCHIP = no;
      INPUT_RK805_PWRKEY = no;
      RTC_DRV_HYM8563 = no;
      SND_SOC_ES8316 = no;
      SENSORS_PWM_FAN = no;
    };

    rockchip = { }: {
      ARCH_SUNXI = no;
      ARCH_QCOM = no;
      ARCH_ROCKCHIP = yes;
      INPUT_RK805_PWRKEY = yes;
      RTC_DRV_HYM8563 = yes;
      SND_SOC_ES8316 = module;
      SENSORS_PWM_FAN = yes;
    };

    denied = { }: {
      ACPI = no;
      AMPERE_ERRATUM_AC03_CPU_38 = no;
      AMPERE_ERRATUM_AC04_CPU_23 = no;
      ARCH_ACTIONS = no;
      ARCH_AIROHA = no;
      ARCH_ALPINE = no;
      ARCH_APPLE = no;
      ARCH_AXIADO = no;
      ARCH_BCM = no;
      ARCH_BERLIN = no;
      ARCH_BLAIZE = no;
      ARCH_BRCMSTB = no;
      ARCH_BST = no;
      ARCH_CIX = no;
      ARCH_EXYNOS = no;
      ARCH_HISI = no;
      ARCH_INTEL_SOCFPGA = no;
      ARCH_K3 = no;
      ARCH_KEEMBAY = no;
      ARCH_LG1K = no;
      ARCH_MA35 = no;
      ARCH_MEDIATEK = no;
      ARCH_MESON = no;
      ARCH_MICROCHIP = no;
      ARCH_MVEBU = no;
      ARCH_NPCM = no;
      ARCH_NXP = no;
      ARCH_REALTEK = no;
      ARCH_RENESAS = no;
      ARCH_SEATTLE = no;
      ARCH_SOPHGO = no;
      ARCH_SPRD = no;
      ARCH_STM32 = no;
      ARCH_SYNQUACER = no;
      ARCH_TEGRA = no;
      ARCH_THUNDER = no;
      ARCH_THUNDER2 = no;
      ARCH_UNIPHIER = no;
      ARCH_VEXPRESS = no;
      ARCH_VISCONTI = no;
      ARCH_XGENE = no;
      ARCH_ZYNQMP = no;
      ARM64_EPAN = no;
      ARM64_ERRATUM_1024718 = no;
      ARM64_ERRATUM_1165522 = no;
      ARM64_ERRATUM_1319367 = no;
      ARM64_ERRATUM_1463225 = no;
      ARM64_ERRATUM_1508412 = no;
      ARM64_ERRATUM_1742098 = no;
      ARM64_ERRATUM_2051678 = no;
      ARM64_ERRATUM_2054223 = no;
      ARM64_ERRATUM_2067961 = no;
      ARM64_ERRATUM_2077057 = no;
      ARM64_ERRATUM_2457168 = no;
      ARM64_ERRATUM_2645198 = no;
      ARM64_ERRATUM_2658417 = no;
      ARM64_ERRATUM_2966298 = no;
      ARM64_ERRATUM_3117295 = no;
      ARM64_ERRATUM_3194386 = no;
      ARM64_ERRATUM_4118414 = no;
      ARM64_ERRATUM_4311569 = no;
      ARM64_ERRATUM_819472 = no;
      ARM64_ERRATUM_824069 = no;
      ARM64_ERRATUM_826319 = no;
      ARM64_ERRATUM_827319 = no;
      ARM64_ERRATUM_832075 = no;
      ARM64_ERRATUM_845719 = no;
      ARM64_GCS = no;
      ARM64_HAFT = no;
      ARM64_LSUI = no;
      ARM64_MTE = no;
      ARM64_PMEM = lib.mkForce no;
      ARM64_POE = no;
      ARM64_SME = no;
      ARM_CCI_PMU = no;
      ARM_CCN = no;
      ARM_CMN = no;
      ARM_DMA350 = no;
      ARM_NI = no;
      ARM_SCMI_POWERCAP = no;
      ARM_SCMI_POWER_CONTROL = no;
      ARM_SCMI_TRANSPORT_OPTEE = no;
      ARM_SCMI_TRANSPORT_VIRTIO = no;
      ARM_SCPI_PROTOCOL = no;
      BCM_SBA_RAID = no;
      CAVIUM_ERRATUM_22375 = no;
      CAVIUM_ERRATUM_23154 = no;
      CAVIUM_ERRATUM_27456 = no;
      CAVIUM_ERRATUM_30115 = no;
      CAVIUM_TX2_ERRATUM_219 = no;
      CORESIGHT = no;
      CPU_SUP_CENTAUR = no;
      CPU_SUP_HYGON = no;
      CPU_SUP_ZHAOXIN = no;
      FSI = no;
      FSL_EDMA = no;
      FSL_QDMA = no;
      FUJITSU_ERRATUM_010001 = no;
      HISILICON_ERRATUM_161600802 = no;
      HISILICON_ERRATUM_162100801 = no;
      HISI_PCIE_PMU = no;
      HISI_PTT = no;
      HNS3_PMU = no;
      HTE = no;
      HYPERV = lib.mkForce no;
      IFCVF = no;
      MV_XOR_V2 = no;
      NVIDIA_CARMEL_CNP_ERRATUM = no;
      OCTEONEP_VDPA = no;
      PCI_HYPERV = no;
      QCOM_FALKOR_ERRATUM_1003 = no;
      QCOM_FALKOR_ERRATUM_1009 = no;
      QCOM_FALKOR_ERRATUM_E1041 = no;
      QCOM_QDF2400_ERRATUM_0065 = no;
      ROCKCHIP_ERRATUM_3568002 = no;
      SNET_VDPA = no;
      SOCIONEXT_SYNQUACER_PREITS = no;
      VBOXSF_FS = no;
      VDPA = no;
      VFIO_AMBA = no;
      VFIO_PLATFORM = no;
      VMWARE_VMCI = no;
      XEN = lib.mkForce no;
      XEN_DOM0 = lib.mkForce no;

      /*
        ARM64_ERRATUM_843419 = yes;
        ARM64_ERRATUM_1418040 = yes;
        ARM64_ERRATUM_1530923 = yes;
        ARM64_WORKAROUND_SPECULATIVE_AT = yes;
        ROCKCHIP_ERRATUM_3588001 = yes;
        STM = no;
        STM_DUMMY = no;
        STM_PROTO_BASIC = no;
        STM_PROTO_SYS_T = no;
        STM_SOURCE_CONSOLE = no;
        STM_SOURCE_FTRACE = no;
        STM_SOURCE_HEARTBEAT = no;
      */
    };
  };
}
