{ inputs, lib, ... }:
{
  flake-file.inputs.armbian = {
    url = "github:armbian/build";
    flake = false;
  };

  kernel.patches.armbian =
     pkgs:
     let
       patcher =
         with lib;
         isRockchip:
         (pkgs.stdenvNoCC.mkDerivation {
           name = "armbian-patches";
           src = inputs.armbian;
           phases = [
             "unpackPhase"
             "buildPhase"
             "installPhase"
           ];
           buildPhase =
             if isRockchip then
               "find $src/patch/kernel/archive/rockchip64-7.1 -maxdepth 1 -name '*.patch' -printf '%f\n' | sort > series.conf"
             else
               ''
                 cp $src/patch/kernel/archive/sunxi-7.0/series.conf ./series.conf
                 sed -i -E '/.*(a83t-suspend-7.0).*/d' series.conf
                 sed -i -E '/.*(arm64-xor-Select-32regs-without-benchmark-to-speed-u).*/d' series.conf
                 sed -i -E '/.*(arm64-dts-rk3399-rockpro64-Add-DMC-nodes).*/d' series.conf
                 sed -i -E '/.*(arm64-dts-rk3399-rockpro64-Add-Type-C-OTG-Alt-DP-sup).*/d' series.conf
                 sed -i -E '/.*(arm64-dts-rk3399-Add-dmc_opp_table).*/d' series.conf
                 sed -i -E '/.*(arm64-dts-rockchip-rk356x-Fix-PCIe-register-map-and-).*/d' series.conf
                 sed -i -E '/.*(arm64-dts-rockchip-rk3399-s-Add-DMC-table).*/d' series.conf
                 sed -i -E '/.*(drm-prime-limit-scatter-list-size-with-dedicated-dma-device).*/d' series.conf
                 sed -i -E '/.*(drv-char-add-dump-reg-sysinfo-drivers).*/d' series.conf
                 sed -i -E '/.*(drv-pci-sunxi-enable-pcie-support).*/d' series.conf
                 sed -i -E '/.*(drm-gem-dma-support-dedicated-dma-device-for-allocation-and-mapping).*/d' series.conf
                 sed -i -E '/.*(drm-sun4i-use-backend-mixer-as-dedicated-dma-device).*/d' series.conf
                 sed -i -E '/.*(drv-media-dvb-frontends-si2168-fix-cmd-timeout).*/d' series.conf
                 sed -i -E '/.*(drv-net-usb-r8152-add-led-configuration-from-of).*/d' series.conf
                 sed -i -E '/.*(video-fbdev-eInk-display-driver-for-A13-based-Pocket).*/d' series.conf
               '';
           installPhase = "cp series.conf $out";
         })
         |> builtins.readFile
         |> splitString "\n"
         |> map strings.trim
         |> filter (line: line != "" && !(hasPrefix "#" line || hasPrefix "-" line))
         |> map (
           path:
           "${inputs.armbian}/patch/kernel/archive/${
             if isRockchip then "rockchip64-7.1" else "sunxi-7.0"
           }/${path}"
         );
     in
     {
       source = inputs.armbian;
       rockchip-patches = patcher true;
       sunxi-patches = patcher false;
     };
 }
