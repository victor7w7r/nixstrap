{
  kernel.config.modules.freq = {
    low = {
      APPLE_BCE = "n";
      HZ = "250";
      HZ_1000 = "n";
      HZ_250 = "y";
      INPUT_JOYSTICK = "n";
      INPUT_TABLET = "n";
      INPUT_TOUCHSCREEN = "n";
      INPUT_UINPUT = "n";
      NO_HZ_FULL = "n";
      NO_HZ_IDLE = "y";
      NR_CPUS = "8";
      NTSYNC = "n";
      PREEMPT = "n";
      PREEMPTION = "n";
      PREEMPT_DYNAMIC = "n";
      PREEMPT_NONE = "y";
      PREEMPT_NONE_BUILD = "y";
      PREEMPT_VOLUNTARY = "n";
      SND = "n";
      SND_JACK = "n";
      SND_OSSEMUL = "n";
      SOUND = "n";
      SND_HDA_CODEC_REALTEK = "n";
      SND_HDA_CODEC_REALTEK_LIB = "n";
    };

    high = {
      ANDROID_BINDERFS = "y";
      ANDROID_BINDER_IPC = "y";
      CACHY = "y";
      HZ = "1000";
      HZ_1000 = "y";
      INPUT_UINPUT = "y";
      NO_HZ_FULL = "y";
      NO_HZ_FULL_NODEF = "y";
      NO_HZ_IDLE = "n";
      NR_CPUS = "32";
      NTSYNC = "y";
      PREEMPT = "y";
      PREEMPTION = "y";
      PREEMPT_BUILD = "y";
      PREEMPT_COUNT = "y";
      PREEMPT_DYNAMIC = "y";
      PREEMPT_NONE = "n";
      PREEMPT_VOLUNTARY = "n";
      RCU_FANOUT = "64";
      RCU_FANOUT_LEAF = "16";
      RCU_BOOST = "y";
      RCU_BOOST_DELAY = "500";
      SCHED_BORE = "y";
      # SND_HDA_CODEC_REALTEK = "y";
      # SND_HDA_CODEC_REALTEK_LIB = "y";
    };
  };
}
