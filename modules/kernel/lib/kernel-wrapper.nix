{ kernel, inputs, ... }:
{
  flake-file.inputs = {
    linux-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
    uwe5622 = {
      url = "github:armbian/uwe5622";
      flake = false;
    };
  };

  kernel.lib = {
    kernel-wrapper =
      pkgs: defconfig: class: dtbMake: isHardened:
      pkgs.stdenvNoCC.mkDerivation {
        name = "kernel-wrapper";
        src = inputs.linux;
        phases = [
          "unpackPhase"
          "patchPhase"
          "installPhase"
        ];
        installPhase = "mkdir -p $out && cp -r . $out/";
        postPatch = ''
          ${pkgs.lib.optionalString isHardened "sed -i 's/static int unprivileged_userns_clone = 1;/extern int unprivileged_userns_clone;/' kernel/fork.c"}
          ${
            if (class != null && dtbMake != null) then
              ''
                find "./arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
                cat <<EOF > "./arch/arm64/boot/dts/Makefile"
                    subdir-y += ${class}
                EOF
                cat <<EOF > "./arch/arm64/boot/dts/${class}/Makefile"
                    ${dtbMake}
                EOF
              ''
            else
              ''
                install -Dm644 ${kernel.lib.defconfig-clear pkgs} arch/x86/configs/cachyos_defconfig
              ''
          }
          ${
            if (class != null && defconfig != null) then
              "install -Dm644 ${defconfig} arch/arm64/configs/armcust_defconfig"
            else
              "cp arch/arm64/configs/defconfig arch/arm64/configs/armcust_defconfig"
          }
          ${pkgs.lib.optionalString (class == "allwinner") ''
            mkdir -p "./drivers/net/wireless/uwe5622"
            cp -R "${inputs.uwe5622}''${uwe5622ver#*:}"/{tty-sdio,unisocwcn,unisocwifi,Kconfig,Makefile} "./drivers/net/wireless/uwe5622"
            echo "obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/" >> ./drivers/net/wireless/Makefile
            sed -i '/source "drivers\/net\/wireless\/ti\/Kconfig"/a source "drivers\/net\/wireless\/uwe5622\/Kconfig"' "./drivers/net/wireless/Kconfig"
          ''}
        '';
      };

    defconfig-clear =
      pkgs:
      pkgs.runCommand "defconfig-clear" { } ''
         cp "${inputs.linux-config}/linux-cachyos/config" config
         #sed -i '/^#/d' config

         #DEBUG
         sed -i '/^CONFIG_CC_/d' config
         sed -i '/^CONFIG_G*CC_/d' config
         sed -i '/^CONFIG_KUNIT$/d' config
         sed -i '/^CONFIG_LD_/d' config
         sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' config
         sed -i '/^CONFIG_RUSTC*_/d' config

         sed -i '/CONFIG_AF_RXRPC/d' config
         sed -i '/CONFIG_ALTERA_STAPL/d' config
         sed -i '/CONFIG_RXKAD/d' config
         sed -i '/^CONFIG_CPU_SUP_/d' config
         sed -i '/^CONFIG_CRYPTO_/d' config
         sed -i '/^CONFIG_DEBUG_/d' config
         sed -i '/^CONFIG_FUSION_/d' config
         sed -i '/^CONFIG_INFINIBAND_/d' config
         sed -i '/^CONFIG_SCSI_/d' config
         sed -i '/^CONFIG_SND_/d' config
         sed -i '/^CONFIG_W1/d' config
         sed -i '/^CONFIG_W1_/d' config
         sed -i '/^CONFIG_XFRM/d' config

        # sed -i '/^CONFIG_BLK_DEV/d' config
        # sed -i '/^CONFIG_COMEDI/d' config
        # sed -i '/^CONFIG_GPIO/d' config
        # sed -i '/^CONFIG_IIO/d' config
        # sed -i '/^CONFIG_MEDIA_/d' config
        # sed -i '/^CONFIG_MEMSTICK_/d' config
        # sed -i '/^CONFIG_MFD_/d' config
        # sed -i '/^CONFIG_MMC_/d' config
        # sed -i '/^CONFIG_NET_/d' config
        # sed -i '/^CONFIG_REGULATOR/d' config
        # sed -i '/^CONFIG_SSB/d' config
        # sed -i '/^CONFIG_SYSTEM/d' config
        # sed -i '/^CONFIG_USB_/d' config

        # sed -i '/^CONFIG_.*_PHY=/d' config
        # sed -i '/^CONFIG_INPUT_/d' config
        # sed -i '/^CONFIG_JOYSTICK_/d' config
        # sed -i '/^CONFIG_PTP_1588_CLOCK/d' config
        # sed -i '/^CONFIG_ATH/d' config

        # sed -i '/^$/N;/\n$/D' config
         cp config "$out"
      '';
  };
}
