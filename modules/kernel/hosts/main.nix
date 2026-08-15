{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "main";

  kernel.hosts.main =
    pkgs: host:
    (kernel.lib.linux {
      inherit pkgs host;
      structuredExtraConfig = kernel.config.default.main;
      localVer = "native";
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
