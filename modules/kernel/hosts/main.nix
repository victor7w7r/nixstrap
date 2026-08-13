{
  inputs,
  kernel,
  ...
}:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "main" false;

  kernel.hosts.main =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.main-generic;
      isArm = false;
      localVer = "native";
      host = "main";
      src = inputs.linux-cachyos-lts;
      #patches = with kernel.patches.injector pkgs; cachyos.bore;
    });
}
