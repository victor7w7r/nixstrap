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
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor (
    pkgs.linux_6_19.override {
      argsOverride = {
        src = pkgs.fetchFromGitea {
          domain = kernelData.sdm845.domain;
          owner = kernelData.sdm845.owner;
          repo = kernelData.sdm845.repo;
          rev = kernelData.sdm845.rev;
          hash = kernelData.sdm845.hash;
        };
        version = kernelData.sdm845.version;
        modDirVersion = kernelData.sdm845.version;
      };
    }
  );
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
