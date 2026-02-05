{ pkgs, inputs }:
let
  kernel = pkgs.cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r";
    lto = "thin";
    processorOpt = "x86_64-v3";
  };
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel}/helpers.nix" { };
  packages = (helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel)).extend (
    _self: _super: { zfs_cachyos = pkgs.cachyosKernels.zfs-cachyos-lto.override { kernel = kernel; }; }
  );
in
{
  inherit kernel packages;
}
