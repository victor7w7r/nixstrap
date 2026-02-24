{ lib, ... }:
with lib.kernel;
{
  common = {
    CACHY = yes;
    MQ_IOSCHED_ADIOS = yes;
    NR_CPUS = lib.mkForce (option (freeform "8192"));
    CC_OPTIMIZE_FOR_PERFORMANCE = no;
    CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
    LOCALVERSION = freeform "v7w7r-lto";
    TRANSPARENT_HUGEPAGE_MADVISE = lib.mkForce no;
    TRANSPARENT_HUGEPAGE_ALWAYS = lib.mkForce yes;
    OVERLAY_FS = module;
    OVERLAY_FS_REDIRECT_DIR = no;
    OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW = yes;
    OVERLAY_FS_INDEX = no;
    OVERLAY_FS_XINO_AUTO = no;
    OVERLAY_FS_METACOPY = no;
    OVERLAY_FS_DEBUG = no;
  };

  bore = {
    SCHED_BORE = yes;
  };

  bbr3 = {
    CONFIG_DEFAULT_FQ_CODEL = no;
    CONFIG_DEFAULT_FQ = yes;
    DEFAULT_BBR = yes;
    DEFAULT_CUBIC = no;
    DEFAULT_TCP_CONG = freeform "bbr";
    NET_SCH_FQ_CODEL = module;
    NET_SCH_FQ = yes;
    TCP_CONG_BBR = yes;
    TCP_CONG_CUBIC = lib.mkForce module;
  };

  procOpt = {
    x86_64-v2 = {
      GENERIC_CPU = yes;
      MZEN4 = no;
      X86_NATIVE_CPU = no;
      X86_64_VERSION = freeform "2";
    };
    x86_64-v3 = {
      GENERIC_CPU = yes;
      MZEN4 = no;
      X86_NATIVE_CPU = no;
      X86_64_VERSION = freeform "3";
    };
    zen4 = {
      GENERIC_CPU = no;
      MZEN4 = yes;
      X86_NATIVE_CPU = no;
    };
    native = {
      GENERIC_CPU = no;
      X86_NATIVE_CPU = yes;
    };
  };

  hzTicks = {
    "300" = {
      HZ_300 = yes;
      HZ = freeform "300";
    };
  };
  /*
    // lib.genAttrs [ "100" "250" "500" "600" "750" "1000" ] (hz: {
      HZ_300 = no;
      "HZ_${hz}" = yes;
      HZ = freeform hz;
    });
  */

  lto = {
    thin = {
      LTO_NONE = no;
      LTO_CLANG_THIN = yes;
      LTO_CLANG_FULL = no;
    };
    full = {
      LTO_NONE = no;
      LTO_CLANG_THIN = no;
      LTO_CLANG_FULL = yes;
    };
  };

  preemptType = {
    full = {
      PREEMPT_DYNAMIC = yes;
      PREEMPT = lib.mkForce yes;
      PREEMPT_VOLUNTARY = lib.mkForce no;
      PREEMPT_LAZY = no;
      PREEMPT_NONE = no;
    };
    none = {
      PREEMPT_DYNAMIC = no;
      PREEMPT = no;
      PREEMPT_VOLUNTARY = lib.mkForce no;
      PREEMPT_LAZY = no;
      PREEMPT_NONE = yes;
    };
  };

  tickrate = {
    idle = {
      HZ_PERIODIC = no;
      NO_HZ_FULL = lib.mkForce no;
      NO_HZ_IDLE = yes;
      NO_HZ = yes;
      NO_HZ_COMMON = yes;
    };
    full = {
      HZ_PERIODIC = no;
      NO_HZ_IDLE = no;
      CONTEXT_TRACKING_FORCE = no;
      NO_HZ_FULL_NODEF = yes;
      NO_HZ_FULL = yes;
      NO_HZ = yes;
      NO_HZ_COMMON = yes;
      CONTEXT_TRACKING = yes;
    };
  };

  asus = {
    ASUS_ARMOURY = module;
    AMD_PRIVATE_COLOR = yes;
    AMD_3D_VCACHE = module;
    V4L2_LOOPBACK = module;
    VHBA = module;
    DRM_APPLETBDRM = module;
    HID_APPLETB_BL = module;
    HID_APPLETB_KBD = module;
    CONTEXT_TRACKING_FORCE = unset;
  };

  /*
    performanceGovernor = {
    CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = no;
    CPU_FREQ_DEFAULT_GOV_PERFORMANCE = yes;
    };
  */

}
