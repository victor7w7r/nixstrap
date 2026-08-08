{ kernel, ... }:
{
  kernel.hosts.generic =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "v2";
      host = "generic";
      structuredExtraConfig = kernel.config.default.main-generic;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "generic";
      cross = "x86_64-unknown-linux-gnu";
    };
}
