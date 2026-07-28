{ inputs, lib, ... }:
{
  flake-file.inputs.armbian = {
    url = "github:armbian/build";
    flake = false;
  };

  kernel.patches.armbian =
    pkgs:
    let
      rockchip = pkgs.stdenvNoCC.mkDerivation {
        name = "rockchip-patches";
        src = inputs.armbian;
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];
        buildPhase = ''
          find $src/patch/kernel/archive/rockchip64-7.1 -maxdepth 1 -name '*.patch' -printf '%f\n' | sort > series.conf
          sed -i -E '/.*(rk3399|helios64|nanopi|rgds|rt5651).*/d' series.conf
          sed -i -E '/.*(media-0007-add-verisilicon-AV1-iommu-driver.patch).*/d' series.conf

        '';
        installPhase = "cp series.conf $out";
      };
      patcher =
        with lib;
        isRockchip:
        (if isRockchip then rockchip else "${inputs.armbian}/patch/kernel/archive/sunxi-7.0/series.conf")
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
  /*
    [
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-warnings.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-park-link-v6.1-post.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-fix-setting-mac-address-for-netdev.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/wireless-uwe5622-Fix-compilation-with-6.7-kernel.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/wireless-uwe5622-reduce-system-load.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-fix-spanning-writes.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-fix-timer-api-changes-for-6.15-only-sunxi.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-v6.17.patch"
      "${fetch.armbian}/patch/misc/wireless-uwe5622/uwe5622-v6.18.patch"
    ]
  */
}
