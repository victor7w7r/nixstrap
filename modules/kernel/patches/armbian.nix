{
  inputs,
  lib,
  kernel-versions,
  self,
  ...
}:
{
  flake-file.inputs = {
    armbian = {
      url = "github:armbian/build";
      flake = false;
    };
    uwe5622 = {
      url = "github:armbian/uwe5622";
      flake = false;
    };
  };

  kernel.patches = {
    rockchip =
      { }:
      map
        (
          patch:
          "${inputs.armbian}/patch/kernel/rk35xx-vendor-${lib.versions.majorMinor kernel-versions.legacy}/${patch}.patch"
        )
        [
          "001-hid-sony"
          "bluetooth-hci-quirk-v6.1-v6.15"
        ];

    sunxi =
      with lib;
      pkgs:
      (pkgs.runCommand "sunxi-patches" { } ''
        cp ${inputs.armbian}/patch/kernel/archive/sunxi-${lib.versions.majorMinor kernel-versions.lts}/series.conf ./series.conf
        sed -i -E '/.*(rk356x|rk3399|add-overlay-compilation).*/d' series.conf
        mv series.conf $out
      '')
      |> builtins.readFile
      |> splitString "\n"
      |> map strings.trim
      |> filter (line: line != "" && !(hasPrefix "#" line || hasPrefix "-" line))
      |> map (
        path:
        "${inputs.armbian}/patch/kernel/archive/sunxi-${lib.versions.majorMinor kernel-versions.lts}/${path}"
      );

    uwe5622 =
      pkgs:
      (pkgs.runCommand "uwe5622-patcher" { } ''
        mkdir -p $out && cp -r ${inputs.linux-latest-lts}/* $out/ && chmod -R +w $out
        mkdir -p "$out/drivers/net/wireless/uwe5622"
        cp -R "${inputs.uwe5622}''${uwe5622ver#*:}"/{tty-sdio,unisocwcn,unisocwifi,Kconfig,Makefile} "$out/drivers/net/wireless/uwe5622"
        echo "obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/" >> $out/drivers/net/wireless/Makefile
        sed -i '/source "drivers\/net\/wireless\/ti\/Kconfig"/a source "drivers\/net\/wireless\/uwe5622\/Kconfig"' "$out/drivers/net/wireless/Kconfig"
      '');

    rk3588 =
      pkgs:
      (pkgs.runCommand "rk3588-patcher"
        {
          nativeBuildInputs = with pkgs; [
            python3
            findutils
          ];
        }
        ''
          mkdir -p $out && cp -r ${inputs.linux-rockchip}/* $out/ && chmod -R +w $out
          python3 ${self}/modules/kernel/patches/patch_drm_exec.py $out/include/drm/drm_exec.h
          find $out/drivers/gpu/arm/bifrost/ -type f \( -name "*.c" -o -name "*.h" \) \
            -exec sed -i 's|\.incbin "drivers/gpu/arm/bifrost/mali_csffw.bin"|\.incbin "mali_csffw.bin"|g' {} +
        ''
      );
  };
}
