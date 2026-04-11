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
    system.android.device_name = "OnePlus6T";
    device = {
      name = "oneplus-fajita";
      supportLevel = "best-effort";
      identity.name = "OnePlus 6T";
    };
    hardware.screen.height = 2340;
  };
}
