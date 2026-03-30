{
  pkgs,
  fetchFromGitHub,
  kernel,
}:
let
  stdenvClang = pkgs.overrideCC pkgs.stdenv pkgs.llvmPackages_20.clang;
in
stdenvClang.mkDerivation rec {
  name = "apple-bce-${version}";
  gitCommit = "5dd96d6ca0dd88d4a500639ed3923e258a81eb3f";
  version = "${gitCommit}";

  src = fetchFromGitHub {
    owner = "deqrocks";
    repo = "apple-bce";
    rev = "${gitCommit}";
    sha256 = "1sf9pzrvvgc9mr0fqjcg6rwxp4j4qv8rdpg7nj8l5nzaj6z0awdj";
  };

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "CC=clang"
    "HOSTCC=clang"
    "ARCH=x86_64"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
