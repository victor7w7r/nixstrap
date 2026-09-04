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
      localVer = "v3";
      src = kernel.lib.kernel-cleaner {
        inherit pkgs;
        src = inputs.linux-lts;
        config = kernel.patches.cachyos-defconfig {
          inherit pkgs;
          selector = "lts";
        };
      };
      patches =
        with kernel.patches.injector pkgs;
        (cachyos.lts { })
        ++ (tachyon.common-x86 { source = inputs.tachyon-patches-lts; })
        ++ (tachyon.lts { })
        ++ (bunker.common { })
        ++ (bunker.lts-x86 { })
        ++ (bunker.lts { });
    });
}
