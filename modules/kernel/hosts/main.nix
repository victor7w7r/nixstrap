{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "main" false;

  kernel.hosts.main =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.main-generic;
      localVer = "native";
      host = "main";
      patches =
        with kernel.patches.injector pkgs;
        (cachyos.lts { }) ++ (bunker.lts { isVanilla = false; }) ++ (tachyon.lts { });
      src =
        inputs.linux-cachyos-lts
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            config = kernel.patches.cachyos-defconfig {
              inherit pkgs;
              selector = "lts";
            };
          }
        );
    });
}
