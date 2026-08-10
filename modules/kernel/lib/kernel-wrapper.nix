{ inputs, lib, ... }: {

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

  kernel.lib.kernel-wrapper =
    {
      pkgs,
      defconfig ? null,
      class ? "x86",
      dtbMake ? "",
    }:
    pkgs.stdenvNoCC.mkDerivation {
      name = "kernel-wrapper";
      src = inputs.linux;
      dontBuild = true;
      dontConfigure = true;
      installPhase = "mkdir -p $out && cp -r . $out/";
      postPatch = ''
        sed -i 's/static int unprivileged_userns_clone = 1;/extern int unprivileged_userns_clone;/' kernel/fork.c
        ${
          if (class != "x86" && dtbMake != "") then
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
              install -Dm644 ${inputs.linux-config}/linux-cachyos/config arch/x86/configs/cachyos_defconfig
            ''
        }
        ${
          if (class != "x86" && defconfig != null) then
            "install -Dm644 ${defconfig} arch/arm64/configs/armcust_defconfig"
          else
            "cp arch/arm64/configs/defconfig arch/arm64/configs/armcust_defconfig"
        }
        ${lib.optionalString (class == "allwinner") ''
          mkdir -p "./drivers/net/wireless/uwe5622"
          cp -R "${inputs.uwe5622}''${uwe5622ver#*:}"/{tty-sdio,unisocwcn,unisocwifi,Kconfig,Makefile} "./drivers/net/wireless/uwe5622"
          echo "obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/" >> ./drivers/net/wireless/Makefile
          sed -i '/source "drivers\/net\/wireless\/ti\/Kconfig"/a source "drivers\/net\/wireless\/uwe5622\/Kconfig"' "./drivers/net/wireless/Kconfig"
        ''}
      '';
    };
}
