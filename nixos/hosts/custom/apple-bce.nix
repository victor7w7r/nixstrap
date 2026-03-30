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
  LLVM = "1";
  src = fetchFromGitHub {
    owner = "deqrocks";
    repo = "apple-bce";
    rev = "${gitCommit}";
    sha256 = "sha256-GHc2EujgUzXttODVPmZUmBgetnBWJSaWPKVMNTdf89w=";
  };

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs =
    with pkgs;
    kernel.moduleBuildDependencies
    ++ [
      clang_20
      llvm_20
      lld_20
    ];

  makeFlags = [
    "CC=clang"
    "HOSTCC=clang"
    "LD=ld.lld"
    "HOSTLD=ld.lld"
    "ARCH=x86_64"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
