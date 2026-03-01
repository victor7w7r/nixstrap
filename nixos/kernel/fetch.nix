{
  pkgs,
  asusPatchesHash,
  asusPatchesRev,
  kernelConfigHash,
  cachyPatchesHash,
  hardened ? false,
}:
{
  kernel-config = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "linux-cachyos";
    rev = "master";
    sha256 = kernelConfigHash;
    postFetch = ''
      hold="$(mktemp -d)" && conf="$hold/conf"
      cp "$out/linux-cachyos-${if hardened then "hardened" else "lts"}/config" "$conf"
      rm -rfv "$out" && cp -v "$conf" "$out"
    '';
  };

  cachy-patches = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "kernel-patches";
    rev = "master";
    sha256 = cachyPatchesHash;
    postFetch = ''
      find "$out" -type f \
        ! -path "*/sched/0001-bore-cachy.patch" \
        ! -path "*/misc/0001-hardened.patch" \
        ! -path "*/misc/0001-acpi-call.patch" \
        ! -path "*/misc/0001-handheld.patch" \
        ! -name "0001-amd-pstate.patch" \
        ! -name "0002-asus.patch" \
        ! -name "0008-intel-pstate.patch" \
        ! -name "0001-cachyos-base-all.patch" \
        ! -name "0009-sched-ext.patch" \
        ! -name "0010-t2.patch" -delete
      find "$out" -type d -empty -delete
    '';
  };

  asus-patches = pkgs.fetchgit {
    url = "https://gitlab.com/asus-linux/linux-g14";
    rev = asusPatchesRev;
    sha256 = asusPatchesHash;
    postFetch = ''find "$out" -type f ! -name "*.patch" -delete'';
  };
}
