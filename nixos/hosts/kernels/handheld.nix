{ pkgs, nix-cachyos-kernel }:
rec {
  helpers = pkgs.callPackage "${nix-cachyos-kernel}/helpers.nix" { };
  packages = helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
  kernel = pkgs.cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r-handheld";
    configVariant = "linux-cachyos-lts";
    version = "6.12.68";
    lto = "thin";
    processorOpt = "zen4";
    handheld = true;
    acpiCall = true;
  };
}
