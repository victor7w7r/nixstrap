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
        cp "${inputs.linux-config}/linux-cachyos${
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
            mkdir -p $out
            cp -r ${inputs.cachyos-patches-unsync}/* ./
            chmod -R +w . && find . -type d -empty -delete
            filterdiff -x "*/security/selinux/selinuxfs.c" "${lib.versions.majorMinor kernel-versions.lts}/misc/0001-hardened.patch" > 0001-hardened-filter.patch
            cat 0001-hardened-filter.patch > "${lib.versions.majorMinor kernel-versions.lts}/misc/0001-hardened.patch"
            rm 0001-hardened-filter.patch && mv ./* $out/
          ''
        |> (
          src:
          map (patch: "${src}/${lib.versions.majorMinor kernel-versions.lts}/${patch}.patch") [
            "misc/0001-aufs-6.18-merge-v20251208"
            "misc/0001-clang-polly"
            "misc/dkms-clang"
            "misc/nap-governor"
          ]
          ++ (pkgs.lib.optional isHardened "${src}/${lib.versions.majorMinor kernel-versions.lts}/misc/0001-hardened.patch")
        )
        |> lib.sort lib.lessThan;
    };
  };
}
