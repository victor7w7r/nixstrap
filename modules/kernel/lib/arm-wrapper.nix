{ inputs, lib, ... }: {

  flake-file.inputs.uwe5622 = {
    url = "github:armbian/uwe5622";
    flake = false;
  };

  kernel.lib.arm-wrapper =
    pkgs: class: dtbMake:
    pkgs.stdenvNoCC.mkDerivation {
      name = "arm-wrapper";
      src = inputs.linux;
      dontBuild = true;
      dontConfigure = true;
      installPhase = "mkdir -p $out && cp -r . $out/";
      postPatch = ''
        ${lib.optionalString (class != "") ''
          find "./arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
          cat <<EOF > "./arch/arm64/boot/dts/Makefile"
              subdir-y += ${class}
          EOF
          cat <<EOF > "./arch/arm64/boot/dts/${class}/Makefile"
              ${dtbMake}
          EOF
        ''}

        ${lib.optionalString (class == "allwinner") ''
          mkdir -p "./drivers/net/wireless/uwe5622"
          cp -R "${inputs.uwe5622}''${uwe5622ver#*:}"/{tty-sdio,unisocwcn,unisocwifi,Kconfig,Makefile} "./drivers/net/wireless/uwe5622"
          echo "obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/" >> ./drivers/net/wireless/Makefile
          sed -i '/source "drivers\/net\/wireless\/ti\/Kconfig"/a source "drivers\/net\/wireless\/uwe5622\/Kconfig"' "./drivers/net/wireless/Kconfig"
          cat drivers/net/wireless/Makefile
          cat drivers/net/wireless/uwe5622/Makefile
        ''}
      '';
    };
}
