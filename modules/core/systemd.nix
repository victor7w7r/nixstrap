{ ... }:

{
  systemd = {
    settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultTimeoutStopSec = "10s";
      DefaultLimitNOFILE = "2048:2097152";
    };
    tmpfiles.rules = [
      "d /tmp       0777 root root 1d"
      "d /var/tmp   0777 root root 3h"
      "d /var/cache 0777 root root 6h"
      "d /var/lib/systemd/coredump 0755 root root 3d"
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
      "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
    ];
  };
}
