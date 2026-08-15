{
  kernel.lib.defconfig-clear =
    {
      pkgs,
      src,
      config ? null,
      arch ? "x86",
      defconfig ? "cachyos_defconfig",
    }:
    pkgs.runCommand "defconfig-clear" { } ''
       cp ${if config != null then config else "${src}/arch/${arch}/configs/defconfig"} config

       sed -i '/^#/d' config

       #DEBUG
       sed -i '/^CONFIG_CC_/d' config
       sed -i '/^CONFIG_G*CC_/d' config
       sed -i '/^CONFIG_KUNIT$/d' config
       sed -i '/^CONFIG_LD_/d' config
       sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' config
       sed -i '/^CONFIG_RUSTC*_/d' config

       sed -i '/^CONFIG_AF_RXRPC/d' config
       sed -i '/^CONFIG_ALTERA_STAPL/d' config
       sed -i '/^CONFIG_COMEDI/d' config
       sed -i '/^CONFIG_CPU_SUP_/d' config
       sed -i '/^CONFIG_CRYPTO_/d' config
       sed -i '/^CONFIG_DEBUG_/d' config
       sed -i '/^CONFIG_FUSION_/d' config
       sed -i '/^CONFIG_GPIO_/d' config
       sed -i '/^CONFIG_INFINIBAND_/d' config
       sed -i '/^CONFIG_KEYBOARD_/d' config
       sed -i '/^CONFIG_RXKAD/d' config
       sed -i '/^CONFIG_SCSI_/d' config
       sed -i '/^CONFIG_SND_/d' config
       sed -i '/^CONFIG_SSB/d' config
       sed -i '/^CONFIG_W1/d' config
       sed -i '/^CONFIG_W1_/d' config
       sed -i '/^CONFIG_XFRM/d' config

      # sed -i '/^CONFIG_.*_PHY=/d' config
      # sed -i '/^CONFIG_ATH/d' config
      # sed -i '/^CONFIG_BLK_DEV/d' config
      # sed -i '/^CONFIG_IIO/d' config
      # sed -i '/^CONFIG_INPUT_/d' config
      # sed -i '/^CONFIG_JOYSTICK_/d' config
      # sed -i '/^CONFIG_MEDIA_/d' config
      # sed -i '/^CONFIG_MEMSTICK_/d' config
      # sed -i '/^CONFIG_MFD_/d' config
      # sed -i '/^CONFIG_MMC_/d' config
      # sed -i '/^CONFIG_NET_/d' config
      # sed -i '/^CONFIG_PTP_1588_CLOCK/d' config
      # sed -i '/^CONFIG_REGULATOR/d' config
      # sed -i '/^CONFIG_SYSTEM/d' config
      # sed -i '/^CONFIG_USB_/d' config

      sed -i '/^$/N;/\n$/D' config

      mkdir -p $out && cp -r ${src}/* $out/ && chmod -R +w $out
      cp config $out/arch/${arch}/configs/${defconfig}
    '';
}
