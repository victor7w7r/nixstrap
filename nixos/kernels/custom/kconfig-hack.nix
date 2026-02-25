{ kernelConfig, runCommand }:
runCommand "kconfig-hack" { } ''
  cp "linux-cachyos-${kernelConfig}" config
  sed -i '/^#/d' config
  # remove meta config related to cc and ld
  sed -i '/^CONFIG_G*CC_/d' config
  sed -i '/^CONFIG_LD_/d' config
  sed -i '/^CONFIG_RUSTC*_/d' config
  sed -i '/^CONFIG_CC_/d' config
  sed -i '/^CONFIG_KUNIT$/d' config
  sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' config
  # remove drivers as they are defined in structured config
  sed -i '/^CONFIG_SND_/d' config
  # sed -i '/^CONFIG_NET_/d' config
  sed -i '/^CONFIG_.*_FS=/d' config
  sed -i '/^CONFIG_MMC_/d' config
  sed -i '/^CONFIG_MEMSTICK_/d' config
  sed -i '/^CONFIG_SYSTEM/d' config
  sed -i '/^CONFIG_MEDIA_/d' config
  sed -i '/^CONFIG_SSB/d' config
  sed -i '/^CONFIG_IIO/d' config
  sed -i '/^CONFIG_USB_/d' config
  # sed -i '/^CONFIG_PHY_/d' config
  # sed -i '/^CONFIG_DRM_/d' config
  # sed -i '/^CONFIG_FB_/d' config
  sed -i '/^CONFIG_MFD_/d' config
  sed -i '/^CONFIG_GPIO/d' config
  sed -i '/^CONFIG_REGULATOR/d' config
  sed -i '/^CONFIG_COMEDI/d' config
  # sed -i '/^CONFIG_SENSORS/d' config
  sed -i '/^CONFIG_BLK_DEV/d' config
  sed -i '/^CONFIG_SCSI_/d' config
  sed -i '/^CONFIG_DEBUG_/d' config
  sed -i '/^CONFIG_.*_PHY=/d' config
  sed -i '/^CONFIG_INPUT_/d' config
  sed -i '/^CONFIG_JOYSTICK_/d' config
  sed -i '/^CONFIG_PTP_1588_CLOCK/d' config
  sed -i '/^CONFIG_ATH/d' config
  # AI: merge multiple empty lines into one
  sed -i '/^$/N;/\n$/D' config
  cp config "$out"
''
