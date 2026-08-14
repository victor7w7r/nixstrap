{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "handheld" true;

  kernel.hosts.handheld =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.handheld;
      localVer = "handheld-native";
      host = "handheld";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.latest.std
        ++ cachyos.latest.handheld
        ++ (bunker.latest { isVanilla = false; })
        ++ tachyon.latest
        ++ asus;
      src =
        inputs.linux-cachyos-latest
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            config = kernel.patches.cachyos-defconfig { inherit pkgs; };
          }
        );
    });
}
