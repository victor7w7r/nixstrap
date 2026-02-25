{ fetchFromGitHub, fetchGit, ... }:
{
  cachyPatches = fetchFromGitHub {
    owner = "CachyOS";
    repo = "kernel-patches";
    rev = "master";
    sha256 = "sha256-io8FpzYJCTMdEuE03r/Qp87CHM65iubAzp8kNbubZEk=";
    postFetch = ''
      find "$out" -type f \
        ! -path "6.18/*" \
        ! -path "6.19/*" \
        ! -name "0001-cachyos-base-all.patch" \
        ! -name "0001-amd-pstate.patch" \
        ! -name "0002-asus.patch" \
        ! -name "0008-intel-pstate.patch" \
        ! -name "0009-sched-ext.patch" \
        ! -name "0010-t2.patch" \
        ! -path "*/misc/0001-hardened.patch" \
        ! -path "*/misc/0001-acpi-call.patch" \
        ! -path "*/misc/0001-handheld.patch" \
        ! -path "*/sched/0001-bore-cachy.patch" -delete
      find "$out" -type d -empty -delete
    '';
  };

  asusPatches = fetchGit {
    url = "https://gitlab.com/asus-linux/linux-g14";
    rev = "6.18";
    sha256 = "sha256-d1GhWEdENpt002r7mmVJ6n4FqJ/W+m8IZJl5ioWDwjo=";
    postFetch = ''
      - rm -rf PKGBUILD
      - rm -rf README
      - rm -rf .gitignore
      - rm -rf .SRCINFO
      - rm -rf choose-gcc-optimization.sh
      - rm -rf chroot-build.sh
      - rm -rf clean-up-patches.sh
      - rm -rf config
    '';
  };

}
