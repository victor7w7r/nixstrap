{ kernel, ... }:
{
  kernel.hosts.main =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "native";
      class = "x86";
      host = "main";
      patches = with kernel.patches.injector pkgs; cachyos.bore;
      structuredExtraConfig = kernel.config.default.main-generic;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "main";
      cross = "x86_64-unknown-linux-gnu";
    };
}
