{
  den.default.nixos.systemd.tmpfiles.rules = [
    "R /srv - - - - -"
    "R /lost+found - - - - -"
    "d /mnt 0755 root root - -"

    "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000"
    "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
    "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
    "w /proc/sys/vm/compaction_proactiveness - - - - 20"
    "w /proc/sys/vm/overcommit_memory - - - - 1"
    "w /proc/sys/vm/overcommit_ratio - - - - 200"
    "w /proc/sys/vm/page_lock_unfairness - - - - 1"
    "w /proc/sys/vm/zone_reclaim_mode - - - - 0"

    "w /sys/kernel/debug/sched/latency_ns  - - - - 1000000"
    "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
    "w /sys/kernel/debug/sched/min_granularity_ns - - - - 500000"
    "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
    "w /sys/kernel/debug/sched/wakeup_granularity_ns  - - - - 0"
    "w /sys/kernel/mm/lru_gen/enabled - - - - 7"
    "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
    "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
    "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
    "w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 1"
    "w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - always"

    /*
      w /proc/sys/vm/watermark_boost_factor - - - - 1
      w /proc/sys/vm/min_free_kbytes - - - - 1048576
      w /proc/sys/vm/watermark_scale_factor - - - - 500
      w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000
      w /proc/sys/vm/swappiness - - - - 10
    */
  ];
}
