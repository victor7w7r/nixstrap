{
  lib,
  final,
  inputs,
  helpers,
  cachyosKernels,
}:
let
  kernel = cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r-hardened";
    lto = "thin";
    processorOpt = "x86_64-v3";
    hardened = true;
  };
  packages = (helpers.kernelModuleLLVMOverride (final.linuxKernel.packagesFor kernel)).extend (
    _self: _super: {
      zfs_cachyos = cachyosKernels.zfs-cachyos-lto.override {
        kernel = kernel;
      };
    }
  );
in
{
  inherit kernel packages;
}
