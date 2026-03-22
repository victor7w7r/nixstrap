{ host }:
if host != "v7w7r-youyeetoox1" then
  [
    "-e ANDROID_BINDERFS"
    "-e ANDROID_BINDER_IPC"
    "-e SCHED_BORE"
    "-e INPUT_UINPUT"
    "-e CACHY"
    "-e NTSYNC"
  ]
else
  [
    "--set-val HZ 300"
    "--set-val NR_CPUS 8"

    "-e BLK_DEV_NVME"
    "-e CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
    "-e CPU_FREQ_GOV_PERFORMANCE"
    "-e CPU_FREQ_GOV_SCHEDUTIL"
    "-e F2FS_FS"
    "-e HZ_300"
    "-e NO_HZ_IDLE"
    "-e PREEMPT_NONE"
    "-e PREEMPT_NONE_BUILD"

    "-m CPU_FREQ_GOV_ONDEMAND"
    "-m INPUT_UINPUT"

    "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-d INPUT_JOYSTICK"
    "-d INPUT_TABLET"
    "-d INPUT_TOUCHSCREEN"
    "-d HZ_1000"
    "-d NO_HZ_FULL"
    "-d NTSYNC"
    "-d PREEMPT"
    "-d PREEMPT_DYNAMIC"
    "-d PREEMPTION"
    "-d PREEMPT_VOLUNTARY"
    "-d SND"
  ]
