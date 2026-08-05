{ kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "handheld-native";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.handheld ++ asus ++ tachyon.gaming ++ bunker.std;
      structuredExtraConfig = kernel.config.handheld;
    })
    |> (generated: {
      handheld-kernelPackages = generated.packages;
      handheld-kernel = generated.kernel;
      handheld-config = generated.config;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "handheld";
      cross = "x86_64-unknown-linux-gnu";
    };
}
