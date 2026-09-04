{
  kernel.lib.kernel-cleaner =
    {
      pkgs,
      src,
      config ? null,
      arch ? "x86",
      defconfig ? "cachyos_defconfig",
      class ? null,
      dtbMake ? "",
    }:
    pkgs.stdenv.mkDerivation {
      pname = "kernel-cleaner";
      version = "latest";

      inherit src;

      dontBuild = true;
      dontConfigure = true;
      installPhase = "mkdir -p $out && cp -r . $out/";

      patchPhase = ''
        cp ${if config != null then config else "${src}/arch/${arch}/configs/defconfig"} config

        sed -i '/^CONFIG_CC_/d' config
        sed -i '/^CONFIG_G*CC_/d' config
        sed -i '/^CONFIG_KUNIT$/d' config
        sed -i '/^CONFIG_LD_/d' config
        sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' config
        sed -i '/^CONFIG_RUSTC*_/d' config
        sed -i '/^CONFIG_LOCALVERSION/d' config

        sed -i '/^CONFIG_.*_PHY=/d' config
        sed -i '/^CONFIG_AF_RXRPC/d' config
        sed -i '/^CONFIG_ALTERA_STAPL/d' config
        sed -i '/^CONFIG_ATALK/d' config
        sed -i '/^CONFIG_ATM/d' config
        sed -i '/^CONFIG_COMEDI/d' config
        sed -i '/^CONFIG_CPU_SUP_/d' config
        sed -i '/^CONFIG_DEBUG_/d' config
        sed -i '/^CONFIG_FUSION_/d' config
        sed -i '/^CONFIG_INFINIBAND_/d' config
        sed -i '/^CONFIG_KEYBOARD_/d' config
        sed -i '/^CONFIG_LAPB/d' config
        sed -i '/^CONFIG_LLC2/d' config
        sed -i '/^CONFIG_PHONET/d' config
        sed -i '/^CONFIG_PHY_QCOM_USB_HS/d' config
        sed -i '/^CONFIG_RDS/d' config
        sed -i '/^CONFIG_RXKAD/d' config
        sed -i '/^CONFIG_SCSI_/d' config
        sed -i '/^CONFIG_SND_/d' config
        sed -i '/^CONFIG_SSB/d' config
        sed -i '/^CONFIG_TIPC/d' config
        sed -i '/^CONFIG_W1*/d' config
        sed -i '/^CONFIG_X25/d' config
        sed -i '/^CONFIG_XFRM/d' config

        # sed -i '/^CONFIG_IIO/d' config
        # sed -i '/^CONFIG_INPUT_/d' config
        # sed -i '/^CONFIG_JOYSTICK_/d' config
        # sed -i '/^CONFIG_MEDIA_/d' config
        # sed -i '/^CONFIG_MEMSTICK_/d' config
        # sed -i '/^CONFIG_MFD_/d' config
        # sed -i '/^CONFIG_MMC_/d' config
        # sed -i '/^CONFIG_PTP_1588_CLOCK/d' config
        # sed -i '/^CONFIG_REGULATOR/d' config
        # sed -i '/^CONFIG_SYSTEM/d' config
        # sed -i '/^CONFIG_USB_/d' config

        sed -i '/^#/d' config
        sed -i '/^$/N;/\n$/D' config

        mkdir -p $out && cp -r ${src}/* $out/ && chmod -R +w $out
        cp config $out/arch/${arch}/configs/${defconfig}

        ${pkgs.lib.optionalString (class != null) ''
          DTS_DIR="arch/${arch}/boot/dts"

          find "$DTS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
          cat <<EOF > "$DTS_DIR/Makefile"
            subdir-y += ${class}
          EOF

          cat <<EOF > "$DTS_DIR/${class}/Makefile"
            ${dtbMake}
          EOF
        ''}
      '';
    };
}
