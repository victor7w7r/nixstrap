{
  den.aspects.pizero.hardware.nixos = { lib, self', ... }: {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 100;
      priority = 100;
    };

    hardware = {
      firmware = with self'.packages; lib.singleton armbian-firmware;
      deviceTree = {
        enable = true;
        filter = "sun50i-h618-orangepi-zero2w.dtb";
        name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
      };
    };
  };
}
