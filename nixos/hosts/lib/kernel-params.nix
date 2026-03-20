{ }:
[
  #"root=${mockDisk}"
  #"rootfstype=${rootfs}"
  #"rootflags=${rootflags}"
  "lsm=landlock,yama,integrity,apparmor,bpf" # check ...lockdown,yama.... lockdown=integrity
  "boot.shell_on_fail"
  #"systemd.log_level=debug"
  #"systemd.log_target=console"
  #"kvmfr.static_size_mb=128"
]
