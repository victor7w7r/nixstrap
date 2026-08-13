{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "server" false;

  kernel.hosts.server =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "server-hardened-native";
      host = "server";
      src = inputs.linux-cachyos-lts;
      #patches = with kernel.patches.injector pkgs; [ hardened ];
      structuredExtraConfig = kernel.config.default.server;
    });
}
