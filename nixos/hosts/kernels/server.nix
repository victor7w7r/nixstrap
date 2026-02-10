{ pkgs, inputs }:
rec {
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel}/helpers.nix" { };
  packages = helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
  kernel = pkgs.cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r-server";
    configVariant = "linux-cachyos-lts";
    lto = "thin";
    version = "6.12.68";
    processorOpt = "x86_64-v2";
    cpusched = "eevdf";
    hzTicks = "300";
    preemptType = "none";
    bbr3 = true;
    hardened = true;
  };
}
