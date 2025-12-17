{
  pkgs,
  lib,
  self,
  ...
}:
with lib;
{
  powerManagement.cpuFreqGovernor = "ondemand";

  fileSystems = {
    "/" = {
      device = "/dev/mapper/vg0-fstemp";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-EFI";
      fsType = "vfat";
      options = [
        "relatime"
        "fmask=0022"
        "dmask=0022"
        "umask=0077"
        "nofail"
      ];
    };
    "/boot/vault" = {
      device = "/dev/disk/by-partlabel/disk-main-vault";
      fsType = "vfat";
      options = [
        "relatime"
        "fmask=0022"
        "dmask=0022"
        "umask=0077"
        "nofail"
      ];
    };
  };

  boot.initrd = {
    luks.devices.system = {
      device = "/dev/disk/by-label/SYSTEM";
      keyFile = "/syskey.key";
      allowDiscards = true;
      preLVM = true;
    };
    #ssh-keygen -t ed25519 -N "" -f ./ssh_host_ed25519_key
    #ssh-keygen -t rsa -N "" -f ./ssh_host_rsa_key
    secrets = {
     "/syskey.key" = builtins.path { path = "${self}/syskey.key"; };
     "/etc/secrets/initrd/ssh_host_ed25519_key" = builtins.path { path = "${self}/ssh_host_ed25519_key"; };
     "/etc/secrets/initrd/ssh_host_rsa_key" = builtins.path { path = "${self}/ssh_host_rsa_key"; };
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
