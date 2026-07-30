{ kernel, inputs, ... }:
{
  kernel.hosts.phone =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "sdm845";
      isArm = true;
      notDenial = true;
      isCachyos = false;
      patches =
        "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
        |> (
          patches:
          with kernel.patches.injector pkgs;
          [ "${patches}/../config_fixes.patch" ]
          ++ (
            (import patches)
            |> builtins.filter (
              item:
              !builtins.elem item.name [
                /*
                  "0001-arm64-dts-qcom-sdm845-xiaomi-beryllium-Enable-ath10k"
                  "0017-arm64-dts-qcom-sdm845-xiaomi-beryllium-Add-haptics-s"
                  "0024-arm64-dts-qcom-sdm845-xiaomi-beryllium-Enable-fuel-g"
                  "0042-hack-ASoC-dt-bindings-qcom-q6dsp-add-internal-mi2s-s"
                */
              ]
            )
            |> map (item: "${patches}/${item.name}.patch")
          )
        );
      extraConfig = with kernel.config.modules; [ qcom ];
    })
    |> (generated: {
      phone-config = generated.config;
      phone-kernelPackages = generated.packages;
      phone-kernel = generated.kernel;
    });

  perSystem =
    { lib, pkgs, ... }:
    lib.mkMerge [
      (
        (kernel.hosts.phone pkgs)
        |> (src: {
          devShells.phone-kconfig = kernel.lib.kconfig {
            inherit pkgs;
            kernel = src.phone-kernel;
          };
          packages = lib.mkAfter {
            phone-config = src.phone-config;
            phone-kernel = src.phone-kernel;
          };
        })
      )
      (
        (kernel.hosts.phone pkgs.pkgsCross.aarch64-multiplatform)
        |> (src: {
          devShells.phone-cross-kconfig = kernel.lib.kconfig {
            pkgs = pkgs.pkgsCross.aarch64-multiplatform;
            kernel = src.phone-kernel;
          };
          packages = lib.mkAfter {
            phone-cross-config = src.phone-config;
            phone-cross-kernel = src.phone-kernel;
          };
        })
      )
    ];
}
