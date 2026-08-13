{ inputs, ... }:
{
  kernel.patches.qcom =
    "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
    |> (
      patches:
      [ "${patches}/../config_fixes.patch" ]
      ++ (
        (import patches)
        |> builtins.filter (
          item:
          !builtins.elem item.name [
            "0107-arm64-dts-qcom-Introduce-support-for-Xiaomi-Mi-Mix-3"
            "0144-hack-scripts-allow-unused-command-line-arguments-wit"
            "0148-dt-bindings-arm-qcom-Add-Xiaomi-Poco-F1-Tianma-varia"
          ]
        )
        |> map (item: "${patches}/${item.name}.patch")
      )
    );
}
