{
  inputs,
  kernelData,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (import ./lib/qcom-845.nix {
      inherit
        inputs
        kernelData
        config
        lib
        pkgs
        ;
    })
  ]
  ++ (import "${inputs.mobile-nixos}/modules/module-list.nix");

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 60;
    priority = 100;
  };

  mobile = {
    system.android.device_name = "OnePlus6";
    device = {
      name = "oneplus-enchilada";
      supportLevel = "supported";
      identity.name = "OnePlus 6";
    };
    hardware.screen.height = 2280;
  };
}
