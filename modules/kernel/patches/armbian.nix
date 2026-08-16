{
  inputs,
  lib,
  kernel-versions,
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
      (pkgs.runCommand "rk3588-patcher" { nativeBuildInputs = [ pkgs.python3 ]; } ''
        mkdir -p $out && cp -r ${inputs.linux-rockchip}/* $out/ && chmod -R +w $out
        sed -i 's|\.incbin "drivers/gpu/arm/bifrost/mali_csffw.bin"|\.incbin "mali_csffw.bin"|g' $out/drivers/gpu/arm/bifrost/csf/mali_kbase_csf_firmware.c
        sed -i 's/goto \*__drm_exec_retry_ptr;/goto __drm_exec_retry;/' $out/include/drm/drm_exec.h

        python3 -c '
              path = "$out/include/drm/drm_exec.h"
              with open(path, "r") as f:
                  content = f.read()

              old_macro = """#define drm_exec_until_all_locked(exec)				\\
         	for (void *__drm_exec_retry_ptr; ({			\\
        		__label__ __drm_exec_retry;			\\
        		__drm_exec_retry_ptr = &&__drm_exec_retry;	\\
        		(void)__drm_exec_retry_ptr;			\\
        		__drm_exec_retry:				\\
        		drm_exec_cleanup(exec);				\\
         	});)"""

              new_macro = """#define drm_exec_until_all_locked(exec)				\\
         	__label__ __drm_exec_retry;				\\
         	__drm_exec_retry:					\\
         	for (bool __retry = ({ (void)&&__drm_exec_retry; true; }); __retry; __retry = false) \\
        		if (drm_exec_cleanup(exec)) {} else"""

              if old_macro in content:
                  content = content.replace(old_macro, new_macro)

              with open(path, "w") as f:
                  f.write(content)
              '
      '');
  };
}
