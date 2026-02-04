{
  lib,
  final,
  inputs,
  helpers,
  cachyosKernels,
}:
let
  kernel = cachyosKernels.linux-cachyos-lts.override {
    pname = "linux-v7w7r-handheld";
    lto = "thin";
    processorOpt = "zen4";
    handheld = true;
    acpiCall = true;
  };
in
{
  inherit kernel;
}
