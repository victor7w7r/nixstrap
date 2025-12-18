{ pkgs, modulesPath, ... }:
let
  systems = import ./common/filesystems.nix;
  params = import ./common/params.nix;
  security = import ./common/security.nix;
  options = import ./common/options.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./../../modules/core)
    (import ./../../modules/home)
  ];

  powerManagement.cpuFreqGovernor = "ondemand";

  fileSystems = {
    "/games" = {
      device = "/dev/disk/by-partlabel/disk-main-games";
      fsType = "btrfs";
      options = options.btrfsOptions;
    };
  }
  // systems { homeDisk = ""; };

  boot = {
    kernelParams = [ ] ++ params { };
    initrd = {
      secrets = security.secrets;
      luks.devices = {
        system = security.system;
      };
    };
  };

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    alsa-plugins
    alsa-utils
    alsa-firmware
    bluetui
    bluetuith
    radeontop
    amdgpu_top
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      extraConfig.pipewire."10-clock-quantum"."context.properties"."default.clock.min-quantum" = 1024;
    };
  };
}
