{ kernel, ... }:
{
  kernel.hosts.generic =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "v2";
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      structuredExtraConfig = kernel.config.default.main-generic;
    })
    |> (generated: {
      generic-kernelPackages = generated.packages;
      generic-kernel = generated.kernel;
      generic-config = generated.config;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "generic";
      cross = "x86_64-unknown-linux-gnu";
    };
}
