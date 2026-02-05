{ pkgs, inputs }:
let
  kernel = pkgs.cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r-handheld";
    lto = "thin";
    processorOpt = "zen4";
    handheld = true;
    acpiCall = true;
  };
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel}/helpers.nix" { };
  packages = helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
in
{
  inherit kernel packages;
}
