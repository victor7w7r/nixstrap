{ kernel, lib, ... }: {
  kernel.config.default = with kernel.config; {
    common = lib.mkMerge [
      disks.include
      filesystems.include
      input.include
      net.include
      performance.include
      peripherals.include
      security.include

      disks.denied
      filesystems.denied
      input.denied
      net.denied
      performance.denied
      peripherals.denied
      security.denied
      sensors.denied
      vendor.denied
    ];
  };
}
