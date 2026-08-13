{
  inputs,
  kernel-versions,
  lib,
  ...
}:
{
  flake-file.inputs = {
    cachyos-patches = {
      url = "github:CachyOS/kernel-patches";
      flake = false;
    };

    cachyos-patches-unsync = {
      url = "github:CachyOS/kernel-patches/c1ba300617a12d257b5721572b9bbe28efae182f";
      flake = false;
    };
  };

  kernel.patches = {
    cachyos-defconfig =
      {
        pkgs,
        selector ? "",
      }:
      pkgs.runCommand "cachyos-defconfig" { } ''
        cp "${inputs.cachyos-config}/linux-cachyos${
          if selector == "" then "" else "-${selector}"
        }/config" $out
      '';

    cachyos = pkgs: {
      latest = {
        bore =
          map
            (
              patch:
              "${inputs.cachyos-patches}/${lib.versions.majorMinor kernel-versions.latest}/sched/${patch}.patch"
            )
            [
              #"0001-bore-cachy"
            ];
        std =
          map
            (
              patch:
              "${inputs.cachyos-patches}/${lib.versions.majorMinor kernel-versions.latest}/misc/${patch}.patch"
            )
            [
              "0001-clang-polly"
              "dkms-clang"
            ];
        handheld =
          map
            (
              patch:
              "${inputs.cachyos-patches}/${lib.versions.majorMinor kernel-versions.latest}/misc/${patch}.patch"
            )
            [
              "0001-acpi-call"
              "0001-handheld"
            ];
      };

      lts =
        {
          isHardened ? false,
        }:
        pkgs.runCommand "cachyos-patches-lts-diff"
          {
            nativeBuildInputs = with pkgs; [
              findutils
              patchutils
            ];
          }
          ''
            cp -r ${inputs.cachyos-patches-unsync} ./work && cd work && chmod -R +w .
            find . -type d -empty -delete

            if [ -f "./${lib.versions.majorMinor kernel-versions.lts}/misc/0001-hardened.patch" ]; then
              filterdiff -x "security/selinux/selinuxfs.c" "./${lib.versions.majorMinor kernel-versions.lts}/misc/0001-hardened.patch" > 0001-hardened-filter.patch || true
              cat 0001-hardened-filter.patch > "./${lib.versions.majorMinor kernel-versions.lts}/misc/0001-hardened.patch" && rm 0001-hardened-filter.patch
            fi
            cp -r . $out
          ''
        |> (
          map
            (
              patch:
              "${inputs.cachyos-patches-unsync}/${lib.versions.majorMinor kernel-versions.lts}/${patch}.patch"
            )
            [
              "0003-bbr3"
              "0004-cachy"
              "0005-crypto"
              "0006-fixes"
              "0008-intel-pstate"
              "0009-sched-ext"
              "0010-t2"
              "misc/0001-aufs-6.18-merge-v20251208"
              "misc/0001-clang-polly"
              "misc/dkms-clang"
              "misc/nap-governor"
              "misc/reflex-governor"
            ]
          ++ (pkgs.lib.optional isHardened "misc/0001-hardened.patch")
        );

      legacy =
        map
          (
            patch: "${inputs.cachyos-patches}/${lib.versions.majorMinor kernel-versions.legacy}/${patch}.patch"
          )
          [
            "0001-bbr2"
            "0002-cachy"
            "0003-clr"
            "0004-ksm"
            "sched/0001-bore-cachy"
            "misc/gcc-lto/0001-gcc-LTO-support-for-the-kernel"
            "misc/gcc-lto/0002-gcc-lto-no-pie"
            "misc/0001-Introduce-per-VMA-lock"
            "misc/0001-bore-tuning"
            "misc/0001-high-hz"
            "misc/0001-mm-add-zblock-new-allocator-for-use-via-zpool-API"
            "misc/0001-mm-introduce-THP-Shrinker"
          ];
    };
  };
}
