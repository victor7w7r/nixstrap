{ kernel, lib, ... }: {
  kernel.config.default = with kernel.config; {
    common = lib.mkMerge [
      (removeAttrs disks.include [ "__provider" ])
      (removeAttrs filesystems.include [ "__provider" ])
      (removeAttrs input.include [ "__provider" ])
      (removeAttrs net.include [ "__provider" ])
      (removeAttrs performance.include [ "__provider" ])
      (removeAttrs peripherals.include [ "__provider" ])
      (removeAttrs security.include [ "__provider" ])
      disks.denied
      filesystems.denied
      input.denied
      net.denied
      (removeAttrs performance.denied [ "__provider" ])
      peripherals.denied
      security.denied
      sensors.denied
      vendor.denied
    ];
  };
}
