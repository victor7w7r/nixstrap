{ host }:
if host != "v7w7r-youyeetoox1" then
  [
    "--set-val HZ 1000"
    "--set-val NR_CPUS 32"

    "-e BLK_DEV_NVME"
    "-e CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
    "-e CPU_FREQ_GOV_PERFORANCE"
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

    "-d NO_HZ_IDLE"
    "-d PREEMPT_NONE"
    "-d PREEMPT_VOLUNTARY"
  ]
else
  [ ]
