{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "handheld";

  kernel.hosts.handheld =
    pkgs: host:
    (kernel.lib.linux {
      inherit pkgs host;
      structuredExtraConfig = kernel.config.default.handheld;
      localVer = "handheld-native";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.latest.std
        ++ cachyos.latest.handheld
        ++ (bunker.latest { isVanilla = false; })
        ++ (tachyon.latest { })
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
