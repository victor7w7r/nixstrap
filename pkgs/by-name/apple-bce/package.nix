{
  main-kernel,
  pkgs,
  inputs,
}:
main-kernel.stdenv.mkDerivation {
  name = "apple-bce";
  version = "latest";
  LLVM = "1";
  src = inputs.apple-bce;

  hardeningDisable = [
    "pic"
    "format"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=unused-command-line-argument"
    "-Wno-unused-command-line-argument"
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
    "LLVM=1"
    "LLVM_IAS=1"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
