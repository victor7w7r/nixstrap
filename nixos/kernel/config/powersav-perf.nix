{ host }:
if host != "v7w7r-higole" && host != "v7w7r-youyeetoox1" then
  [
    "--set-val HZ 1000"
    "--set-val NR_CPUS 32"

    "-e BLK_DEV_NVME"
    "-e CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-e CPU_FREQ_GOV_SCHEDUTIL"
    "-e HZ_1000"
    "-e NO_HZ_FULL"
    "-e NO_HZ_FULL_NODEF"
    "-e PCIE_BUS_PERFORMANCE"
    "-e PREEMPT_BUILD"
    "-e PREEMPTION"
    "-e PREEMPT"
    "-e PREEMPT_COUNT"
    "-e PREEMPT_DYNAMIC"

    "-m F2FS_FS"
    "-m CPU_FREQ_GOV_PERFORMANCE"
    "-m CPU_FREQ_GOV_CONSERVATIVE"
    "-m CPU_FREQ_GOV_ONDEMAND"

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
    "-e CPU_FREQ_GOV_POWERSAVE"
    "-e CPU_FREQ_GOV_SCHEDUTIL"
    "-e CONTEXT_TRACKING"
    "-e F2FS_FS"
    "-e HZ_300"
    "-e MMC"
    "-e NO_HZ_IDLE"
    "-e PCIEASPM_POWERSAVE"
    "-e PREEMPT_VOLUNTARY"
    "-e SND_HDA_POWER_SAVE"
    "-e TOUCHSCREEN_GOODIX"
    "-e USB_AUTOSUSPEND"
    "-e X86_PKG_TEMP_THERMAL"

    "-m RTW88"
    "-m CPU_FREQ_GOV_CONSERVATIVE"
    "-m CPU_FREQ_GOV_ONDEMAND"

    "-d BLK_DEV_NVME"
    "-d CONTEXT_TRACKING_FORCE"
    "-d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-d CPU_FREQ_GOV_PERFORMANCE"
    "-d NO_HZ_FULL"
    "-d PREEMPT"
    "-d PREEMPT_DYNAMIC"
    "-d PREEMPTION"
  ]
else
  [ ]
