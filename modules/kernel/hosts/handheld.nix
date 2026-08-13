{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "handheld" true;

  kernel.handheld =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "handheld-native";
      host = "handheld";
      structuredExtraConfig = kernel.config.default.handheld;
      src = inputs.linux-cachyos-latest;
      #patches = with kernel.patches.injector pkgs; cachyos.handheld ++ asus;
    });
}
