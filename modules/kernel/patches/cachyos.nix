{ inputs, ... }:
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

  kernel.patches.cachyos = pkgs: {
    latest = {
      bore = map (patch: "${inputs.cachyos-patches}/7.1/sched/${patch}.patch") [
        #"0001-bore-cachy"
      ];
      std = map (patch: "${inputs.cachyos-patches}/7.1/misc/${patch}.patch") [
        "0001-clang-polly"
        "dkms-clang"
      ];
      handheld = map (patch: "${inputs.cachyos-patches}/7.1/misc/${patch}.patch") [
        "0001-acpi-call"
        "0001-handheld"
      ];
    };
    lts =
      {
        isHardened ? false,
      }:
      pkgs.runCommand "cachyos-patches-lts-diff" {
        nativeBuildInputs = with pkgs; [
          findutils
          patchutils
        ];
      } ''
        cp -r ${inputs.cachyos-patches-unsync} ./work && cd work && chmod -R +w .
        find . -type d -empty -delete

        if [ -f "./6.18/misc/0001-hardened.patch" ]; then
          filterdiff -x "security/selinux/selinuxfs.c" "./6.18/misc/0001-hardened.patch" > 0001-hardened-filter.patch || true
          cat 0001-hardened-filter.patch > "./6.18/misc/0001-hardened.patch" && rm 0001-hardened-filter.patch
        fi
        cp -r . $out
      ''
      |> (
        map (patch: "${inputs.cachyos-patches-unsync}/6.18/${patch}.patch") [
          "0003-bbr3"
          "0004-cachy"
          "0005-crypto"
          "0006-fixes"
          "0008-intel-pstate"
          "0009-sched-ext"
          "misc/0001-aufs-6.18-merge-v20251208"
          "misc/0001-clang-polly"
          "misc/dkms-clang"
          "misc/nap-governor"
          "misc/reflex-governor"
        ]
        ++ (pkgs.lib.optional isHardened "misc/0001-hardened.patch")
      );
    legacy = map (patch: "${inputs.cachyos-patches}/6.1/${patch}.patch") [
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
}
