{ inputs, kernel, ... }:
{
  #inputs.nixpkgs-gcc11.url = "github:NixOS/nixpkgs/nixos-24.05";

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen pkgs "handheld" "x86_64-linux" pkgs.stdenv.hostPlatform.system;

  kernel.hosts.handheld =
    pkgs: host: arch: system:
    (kernel.lib.linux {
      inherit
        pkgs
        host
        arch
        system
        ;
      structuredExtraConfig = kernel.config.default.handheld;
      localVer = "handheld-native";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.latest.std
        ++ cachyos.latest.handheld
        ++ (bunker.latest { isVanilla = false; })
        ++ (tachyon.latest { })
        ++ asus;
      src =
        inputs.linux-cachyos-latest
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            config = kernel.patches.cachyos-defconfig { inherit pkgs; };
          }
        );
    });
}
