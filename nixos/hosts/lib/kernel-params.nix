{ }:
[
  #"root=${mockDisk}"
  #"rootfstype=${rootfs}"
  #"rootflags=${rootflags}"
  #rotate:2
  "boot.shell_on_fail"
  #"systemd.log_level=debug"
  #"console=tty0"
  #"console=ttyS0,115200n8"
  #"earlyprintk=ttyS0,11520"
  #"systemd.log_target=console"
  #"kvmfr.static_size_mb=128"
]
