{ lib, ... }: {
  kernel.config.flavour = with lib.kernel; {
    server = {
      HZ = freeform "250";
      HZ_1000 = no;
      HZ_250 = yes;
      INPUT_TABLET = no;
      INPUT_UINPUT = no;
      NO_HZ_FULL = no;
      NO_HZ_IDLE = yes;
      NR_CPUS = freeform "8";
      NTSYNC = no;
      PREEMPT = no;
      PREEMPTION = no;
      PREEMPT_DYNAMIC = no;
      PREEMPT_NONE = yes;
      PREEMPT_NONE_BUILD = yes;
      PREEMPT_VOLUNTARY = no;
      SND = no;
      SND_HDA_CODEC_REALTEK = no;
      SND_HDA_CODEC_REALTEK_LIB = no;
      SND_JACK = no;
      SND_OSSEMUL = no;
      SOUND = no;
    };

    desktop = {
      ANDROID_BINDERFS = yes;
      ANDROID_BINDER_IPC = yes;
      CACHY = yes;
      HZ = freeform "1000";
      HZ_1000 = yes;
      INPUT_UINPUT = yes;
      NO_HZ_FULL = yes;
      NO_HZ_IDLE = no;
      NR_CPUS = freeform "32";
      NTSYNC = yes;
      PREEMPT = yes;
      PREEMPTION = yes;
      PREEMPT_BUILD = yes;
      PREEMPT_COUNT = yes;
      PREEMPT_DYNAMIC = yes;
      PREEMPT_NONE = no;
      PREEMPT_VOLUNTARY = no;
      RCU_BOOST = yes;
      RCU_BOOST_DELAY = freeform "500";
      RCU_FANOUT = freeform "64";
      RCU_FANOUT_LEAF = freeform "16";
      SCHED_BORE = yes;
      SND = yes;
      SND_HRTIMER = yes;
      SND_SEQUENCER = yes;
      SND_SOC = yes;
      SND_SOC_HDA = yes;
      SOUND = yes;
    };
  };
}
