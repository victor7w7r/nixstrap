{
  pkgs,
  kernelData,
  majorMinor ? null,
  hardened ? false,
  isLegacy ? false,
  ...
}:
{
  linux = pkgs.fetchurl {
    url = kernelData.linux.url;
    hash = kernelData.linux.hash;
  };

  linux-legacy = pkgs.fetchurl {
    url = kernelData.linux-legacy.url;
    hash = kernelData.linux-legacy.hash;
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

  bunker = pkgs.fetchFromGitHub {
    owner = kernelData.bunker.user;
    repo = kernelData.bunker.repo;
    rev = kernelData.bunker.rev;
    hash = kernelData.bunker.hash;
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
    sha256 = if isLegacy then kernelData.patches.legacyHash else kernelData.patches.hash;
    postFetch = ''
      find "$out" -type d -empty -delete
        ${
          if isLegacy then
            ''
              ${pkgs.patchutils}/bin/filterdiff -x "*/kernel/sysctl.c" -x "*/kernel/user_namespace.c" \
              -x "*/include/linux/user_namespace.h" \
              "$out/${majorMinor}/0003-cachy.patch" > cachy-filter.patch
              cat cachy-filter.patch > "$out/${majorMinor}/0003-cachy.patch"
            ''
          else
            ''
              ${pkgs.patchutils}/bin/filterdiff -x "*/drivers/gpu/drm/amd/*" \
              "$out/${majorMinor}/0007-hdmi.patch" > hdmi-filter.patch || true
              cat hdmi-filter.patch > "$out/${majorMinor}/0007-hdmi.patch" || true

              ${pkgs.patchutils}/bin/filterdiff -x "*/drivers/hid/Makefile" \
              -x "*/drivers/input/joystick/xpad.c" \
              "$out/${majorMinor}/misc/0001-handheld.patch" > handheld-filter.patch || true
              cat handheld-filter.patch > "$out/${majorMinor}/misc/0001-handheld.patch" || true
            ''
        }
    '';
  };

  sunxi-kconfig = pkgs.fetchFromGitHub {
    owner = kernelData.sunxi-kconfig.user;
    repo = kernelData.sunxi-kconfig.repo;
    rev = kernelData.sunxi-kconfig.rev;
    hash = kernelData.sunxi-kconfig.hash;
    postFetch = ''
      hold="$(mktemp -d)" && conf="$hold/conf"
      cp "$out/config/kernel/linux-sunxi-legacy.config" "$conf"
      rm -rfv "$out" && cp -v "$conf" "$out"
    '';
  };

  sunxi = pkgs.fetchFromGitHub {
    owner = kernelData.sunxi-opizero2w.user;
    repo = kernelData.sunxi-opizero2w.repo;
    rev = kernelData.sunxi-opizero2w.rev;
    hash = kernelData.sunxi-opizero2w.hash;
  };

  sdm845 = pkgs.fetchFromGitea {
    domain = kernelData.sdm845.domain;
    owner = kernelData.sdm845.owner;
    repo = kernelData.sdm845.repo;
    rev = kernelData.sdm845.rev;
    hash = kernelData.sdm845.hash;
  };
}
