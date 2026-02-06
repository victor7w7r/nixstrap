{ pkgs, nix-cachyos-kernel }:
rec {
  helpers = pkgs.callPackage "${nix-cachyos-kernel}/helpers.nix" { };
  packages = helpers.kernelModuleLLVMOverride (pkgs.linuxPackagesFor kernel);
  kernel = pkgs.cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r";
    version = "6.12.68";
    lto = "thin";
    processorOpt = "x86_64-v3";
    configVariant = "linux-cachyos-lts";
  };
}
