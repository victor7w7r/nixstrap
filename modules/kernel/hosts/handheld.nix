{ kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "handheld-native";
      class = "x86";
      host = "handheld";
      structuredExtraConfig = kernel.config.default.handheld;
      patches = with kernel.patches.injector pkgs; cachyos.handheld ++ asus;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "handheld";
      cross = "x86_64-unknown-linux-gnu";
    };
}
