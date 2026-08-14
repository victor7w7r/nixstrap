{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "server" false;

  kernel.hosts.server =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.server;
      localVer = "server-hardened-native";
      host = "server";
      patches =
        with kernel.patches.injector pkgs;
        (cachyos.lts { isHardened = true; }) ++ (bunker.lts { isVanilla = false; }) ++ (tachyon.lts { });
      src =
        inputs.linux-cachyos-lts
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit src pkgs;
            config = kernel.patches.cachyos-defconfig {
              inherit pkgs;
              selector = "hardened";
            };
          }
        );
    });
}
