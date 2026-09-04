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
      localVer = "handheld-zen4";
      src = kernel.lib.kernel-cleaner {
        inherit pkgs;
        src = inputs.linux-latest;
        config = kernel.patches.cachyos-defconfig { inherit pkgs; };
      };
      patches =
        with kernel.patches.injector pkgs;
        cachyos.latest.std
        ++ cachyos.latest.handheld
        ++ (tachyon.common-x86 { source = inputs.tachyon-patches-latest; })
        ++ (tachyon.latest { })
        ++ (map (patch: "${inputs.tachyon-patches-latest}/patches/${patch}.patch") [
          "0001-ACPI-processor-Disable-bus-master-check-for-AMD"
          "0002-drm-amd-display_Fix_high_busy_wait_load_in_dmub_srv_wait_for_idle"
        ])
        ++ (bunker.common { isLts = false; })
        ++ (bunker.latest-x86 { })
        ++ (bunker.latest { })
        ++ asus;
    });
}
