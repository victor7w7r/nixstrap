{
  main-kernel,
  pkgs,
  inputs,
  llvmPackages,
  overrideCC,
  stdenv,
}:
(overrideCC stdenv llvmPackages.clang).mkDerivation {
  name = "apple-bce";
  version = "latest";
  LLVM = "1";

  src = inputs.apple-bce;

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs =
    with pkgs;
    main-kernel.moduleBuildDependencies
    ++ [
      clang
      llvm
      lld
    ];

  makeFlags = [
    "CC=clang"
    "HOSTCC=clang"
    "LD=ld.lld"
    "HOSTLD=ld.lld"
    "ARCH=x86_64"
    "KERNELRELEASE=${main-kernel.modDirVersion}"
    "KDIR=${main-kernel.dev}/lib/modules/${main-kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
