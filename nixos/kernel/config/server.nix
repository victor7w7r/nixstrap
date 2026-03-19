{ host }:
if host != "v7w7r-youyeetoox1" then
  [
    "-e ANDROID_BINDERFS"
    "-e ANDROID_BINDER_IPC"
    "-e CACHY"
    "-e SCHED_BORE"
    "-e SCHED_CLASS_EXT"
    "-e NTSYNC"
  ]
else
  [
    "--set-val HZ 300"
    "--set-val NR_CPUS 8"

    "-d CACHY"
    "-e BLK_DEV_NVME"
    "-e CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
    "-e CPU_FREQ_GOV_ONDEMAND"
    "-e CPU_FREQ_GOV_PERFORMANCE"
    "-e CPU_FREQ_GOV_SCHEDUTIL"
    "-e HZ_300"
    "-e NO_HZ_IDLE"
    "-e PREEMPT_NONE"
    "-e PREEMPT_NONE_BUILD"

    "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-d INPUT_JOYSTICK"
    "-d INPUT_TABLET"
    "-d INPUT_TOUCHSCREEN"
    "-d NO_HZ_FULL"
    "-d NTSYNC"
    "-d PREEMPT"
    "-d PREEMPT_DYNAMIC"
    "-d PREEMPTION"
    "-d PREEMPT_VOLUNTARY"
    "-d SND"
  ]
