{ kernel, ... }:
{
  kernel.hosts.server =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "server-hardened-native";
      host = "server";
      patches = with kernel.patches.injector pkgs; cachyos.hardened ++ bunker.hardened;
      structuredExtraConfig = kernel.config.default.server;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "server";
      cross = "x86_64-unknown-linux-gnu";
    };
}
