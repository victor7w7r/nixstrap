{ inputs, kernel, ... }:
{
  perSystem =
    { pkgs, ... }: kernel.lib.package-gen pkgs "server" "x86_64-linux" pkgs.stdenv.hostPlatform.system;

  kernel.hosts.server =
    pkgs: host: arch: system:
    (kernel.lib.linux {
      inherit
        pkgs
        host
        arch
        system
        ;
      structuredExtraConfig = kernel.config.default.server;
      localVer = "server-hardened-v2";
      patches =
        with kernel.patches.injector pkgs;
        (cachyos.lts { isHardened = true; })
        ++ (tachyon.common-x86 { source = inputs.tachyon-patches-lts; })
        ++ (tachyon.lts { })
        ++ (bunker.common { })
        ++ (bunker.lts-x86 { })
        ++ (bunker.lts { })
        ++ (bunker.hardening { });
      src =
        inputs.linux-lts
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
