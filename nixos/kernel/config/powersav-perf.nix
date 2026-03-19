{ host }:
if host != "v7w7r-higole" && host != "v7w7r-youyeetoox1" then
  [
    "--set-val HZ 1000"
    "--set-val NR_CPUS 32"

    "-e BLK_DEV_NVME"
    "-e CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-e CPU_FREQ_GOV_CONSERVATIVE"
    "-e CPU_FREQ_GOV_ONDEMAND"
    "-e CPU_FREQ_GOV_PERFORMANCE"
    "-e CPU_FREQ_GOV_SCHEDUTIL"
    "-e HZ_1000"
    "-e INPUT_UINPUT"
    "-e NO_HZ_FULL"
    "-e NO_HZ_FULL_NODEF"
    "-e PREEMPT_BUILD"
    "-e PREEMPTION"
    "-e PREEMPT"
    "-e PREEMPT_COUNT"
    "-e PREEMPT_DYNAMIC"

    "-d NO_HZ_IDLE"
    "-d PREEMPT_NONE"
    "-d PREEMPT_VOLUNTARY"
  ]
else if host == "v7w7r-higole" then
  [
    "--set-val HZ 300"
    "--set-val NR_CPUS 8"
    "--set-val SND_HDA_POWER_SAVE_DEFAULT 1"

    "-e CPU_FREQ_DEFAULT_GOV_POWERSAVE"
    "-e CPU_FREQ_GOV_CONSERVATIVE"
    "-e CPU_FREQ_GOV_ONDEMAND"
    "-e CPU_FREQ_GOV_POWERSAVE"
    "-e CPU_FREQ_GOV_SCHEDUTIL"
    "-e HZ_300"
    "-e INPUT_UINPUT"
    "-e MMC"
    "-e NO_HZ_IDLE"
    "-e PCIEASPM_POWERSAVE"
    "-e PREEMPT_VOLUNTARY"
    "-e SND_HDA_POWER_SAVE"
    "-e USB_AUTOSUSPEND"
    "-e RTW88"
    "-e TOUCHSCREEN_GOODIX"
    "-e X86_PKG_TEMP_THERMAL"

    "-d BLK_DEV_NVME"
    "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-d CPU_FREQ_GOV_PERFORMANCE"
    "-d NO_HZ_FULL"
    "-d PREEMPT"
    "-d PREEMPT_DYNAMIC"
    "-d PREEMPTION"
  ]
else
  [ ]
