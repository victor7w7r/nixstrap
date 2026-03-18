{
  pkgs,
  kernelData,
  majorMinor,
  hardened,
  ...
}:
{
  linux = pkgs.fetchurl {
    url = "${kernelData.linux.url}/linux-${kernelData.linux.version}.tar.xz";
    hash = kernelData.linux.hash;
  };

  asus = pkgs.fetchgit {
    url = kernelData.asus.url;
    rev = kernelData.asus.rev;
    sha256 = kernelData.asus.hash;
    postFetch = ''find "$out" -type f ! -name "*.patch" -delete'';
  };

  tachyon = pkgs.fetchgit {
    url = kernelData.tachyon.url;
    rev = kernelData.tachyon.rev;
    sha256 = kernelData.tachyon.hash;
  };

  tkg = pkgs.fetchFromGitHub {
    owner = kernelData.tkg.owner;
    repo = kernelData.tkg.repo;
    rev = kernelData.tkg.rev;
    sha256 = kernelData.tkg.hash;
  };

  kConfig = pkgs.fetchFromGitHub {
    owner = kernelData.user;
    repo = kernelData.config.repo;
    rev = kernelData.config.rev;
    sha256 = kernelData.config.hash;
    postFetch = ''
      hold="$(mktemp -d)" && conf="$hold/conf"
      cp "$out/linux-cachyos-${if hardened then "hardened" else "lts"}/config" "$conf"
      sed -i '/^#/d' $conf
      sed -i '/^CONFIG_G*CC_/d' $conf
      sed -i '/^CONFIG_ATH/d' $conf
      sed -i '/^CONFIG_LD_/d' $conf
      sed -i '/^CONFIG_RUSTC*_/d' $conf
      sed -i '/^CONFIG_KUNIT$/d' $conf
      sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' $conf
      sed -i '/^CONFIG_MEMSTICK_/d' $conf
      sed -i '/^CONFIG_SYSTEM/d' $conf
      sed -i '/^CONFIG_MEDIA_/d' $conf
      sed -i '/^CONFIG_SSB/d' $conf
      sed -i '/^CONFIG_COMEDI/d' $conf
      sed -i '/^CONFIG_.*_PHY=/d' $conf
      sed -i '/^CONFIG_PTP_1588_CLOCK/d' $conf
      sed -i '/^$/N;/\n$/D' $conf
      rm -rfv "$out" && cp -v "$conf" "$out"
    '';
  };

  patches = pkgs.fetchFromGitHub {
    owner = kernelData.user;
    repo = kernelData.patches.repo;
    rev = kernelData.patches.rev;
    sha256 = kernelData.patches.hash;
    postFetch = ''
      find "$out" -type d -empty -delete

        ${pkgs.patchutils}/bin/filterdiff -x "*/include/net/tcp.h" \
        "$out/${majorMinor}/0003-bbr3.patch" > bbr3-filter.patch
        cat bbr3-filter.patch > "$out/${majorMinor}/0003-bbr3.patch"
    '';
  };
}
