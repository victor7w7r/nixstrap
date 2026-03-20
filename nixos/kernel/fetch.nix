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

  kConfig = pkgs.fetchFromGitHub {
    owner = kernelData.user;
    repo = kernelData.config.repo;
    rev = kernelData.config.rev;
    sha256 = if hardened then kernelData.config.hashHardened else kernelData.config.hash;
    postFetch = ''
      hold="$(mktemp -d)" && conf="$hold/conf"
      cp "$out/linux-cachyos-${if hardened then "hardened" else "lts"}/config" "$conf"
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

        ${pkgs.patchutils}/bin/filterdiff -x "*/drivers/gpu/drm/amd/*" \
        "$out/${majorMinor}/0007-hdmi.patch" > hdmi-filter.patch
        cat hdmi-filter.patch > "$out/${majorMinor}/0007-hdmi.patch"

        ${pkgs.patchutils}/bin/filterdiff -x "*/drivers/hid/Makefile" \
        "$out/${majorMinor}/misc/0001-handheld.patch" > handheld-filter.patch
        cat handheld-filter.patch > "$out/${majorMinor}/misc/0001-handheld.patch"

        ${pkgs.patchutils}/bin/filterdiff -x "*/drivers/gpu/drm/i915/display/*" \
        "$out/${majorMinor}/0010-t2.patch" > t2-filter.patch
        cat t2-filter.patch > "$out/${majorMinor}/0010-t2.patch"
    '';
  };
}
