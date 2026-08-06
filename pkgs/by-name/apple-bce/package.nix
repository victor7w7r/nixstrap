{ main-kernel, inputs }:
main-kernel.stdenv.mkDerivation {
  name = "apple-bce";
  version = "latest";
  src = inputs.apple-bce;

  nativeBuildInputs = main-kernel.moduleBuildDependencies;

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
