{
  inputs,
  lib,
  kernel-versions,
  kernel,
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

  kernel.patches.armbian = {
    patcher =
      with lib;
      pkgs:
      isRockchip:
      (pkgs.runCommand "armbian-patches" { } ''
        ${
          if isRockchip then
            "find $src/patch/kernel/archive/rockchip64-${lib.versions.majorMinor kernel-versions.lts} -maxdepth 1 -name '*.patch' -printf '%f\n' | sort > series.conf"
          else
            ''
              cp ${inputs.armbian}/patch/kernel/archive/sunxi-${lib.versions.majorMinor kernel-versions.lts}/series.conf ./series.conf
              sed -i -E '/.*(rk356x|rk3399|add-overlay-compilation).*/d' series.conf
            ''
        }
         mv series.conf $out
      '')
      |> builtins.readFile
      |> splitString "\n"
      |> map strings.trim
      |> filter (line: line != "" && !(hasPrefix "#" line || hasPrefix "-" line))
      |> map (
        path:
        "${inputs.armbian}/patch/kernel/archive/${
          if isRockchip then "rockchip64" else "sunxi"
        }-${lib.versions.majorMinor kernel-versions.lts}/${path}"
      );

    sunxi = pkgs: kernel.patches.armbian.patcher pkgs false;
    rockchip = pkgs: kernel.patches.armbian.patcher pkgs true;

    uwe5622 =
      pkgs:
      (pkgs.runCommand "uwe5622-patcher" { } ''
        mkdir -p $out && cp -r ${inputs.linux-lts}/* $out/ && chmod -R +w $out
        mkdir -p "$out/drivers/net/wireless/uwe5622"
        cp -R "${inputs.uwe5622}''${uwe5622ver#*:}"/{tty-sdio,unisocwcn,unisocwifi,Kconfig,Makefile} "$out/drivers/net/wireless/uwe5622"
        echo "obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/" >> $out/drivers/net/wireless/Makefile
        sed -i '/source "drivers\/net\/wireless\/ti\/Kconfig"/a source "drivers\/net\/wireless\/uwe5622\/Kconfig"' "$out/drivers/net/wireless/Kconfig"
      '');

    legacy-rockchip =
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

    legacy-rk3588 =
      pkgs:
      (pkgs.runCommand "rk3588-patcher"
        {
          nativeBuildInputs = with pkgs; [ findutils ];
        }
        ''
          mkdir -p $out && cp -r ${inputs.linux-rockchip}/* $out/ && chmod -R +w $out
          FW_PATH="$out/drivers/gpu/arm/bifrost/mali_csffw.bin"
          find $out/drivers/gpu/arm/bifrost/ -type f \( -name "*.c" -o -name "*.S" -o -name "*.h" \) \
              -exec sed -i "s|drivers/gpu/arm/bifrost/mali_csffw.bin|$FW_PATH|g" {} +
        ''
      );
  };
}
