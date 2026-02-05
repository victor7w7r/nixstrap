{ pkgs, inputs }:
let
  kernel = pkgs.cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r-server";
    lto = "thin";
    processorOpt = "x86_64-v3";
    cpusched = "eevdf";
    hzTicks = "300";
    preemptType = "none";
    bbr3 = true;
    hardened = true;
  };
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel}/helpers.nix" { };
  packages = (helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel)).extend (
    _self: _super: { zfs_cachyos = pkgs.cachyosKernels.zfs-cachyos-lto.override { kernel = kernel; }; }
  );
in
{
  inherit kernel packages;
}
