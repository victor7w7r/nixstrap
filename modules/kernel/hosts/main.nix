{ inputs, kernel, ... }:
{
  perSystem =
    { pkgs, ... }: kernel.lib.package-gen pkgs "main" "x86_64-linux" pkgs.stdenv.hostPlatform.system;

  kernel.hosts.main =
    pkgs: host: arch: system:
    (kernel.lib.linux {
      inherit
        pkgs
        host
        arch
        system
        ;
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
