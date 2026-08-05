{ kernel, ... }:
{
  kernel.hosts.server =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "server-hardened-native";
      patches = with kernel.patches.injector pkgs; cachyos.hardened ++ tachyon.std ++ bunker.hardened;
      structuredExtraConfig = kernel.config.default.server;
    })
    |> (generated: {
      server-config = generated.config;
      server-kernelPackages = generated.packages;
      server-kernel = generated.kernel;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "server";
      cross = "x86_64-unknown-linux-gnu";
    };
}
