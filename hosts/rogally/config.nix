{ pkgs, lib, ... }:
with lib;
{
  powerManagement.cpuFreqGovernor = "ondemand";

  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = {
      maindevice = "/dev/vda";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg0-home";
      varDisk = "/dev/mapper/vg0-var";
    };

    fileSystems = {
      "/" = {
        device = "/dev/mapper/vg0-fstemp";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-partlabel/disk-main-EFI";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
    };

    environment = {
      defaultPackages = [ ];
      systemPackages = with pkgs; [
        alsa-plugins
        alsa-utils
        alsa-firmware
        bluetui
        bluetuith
        radeontop
        amdgpu_top
      ];
    };

    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      cpu.amd.updateMicrocode = true;
      enableRedistributableFirmware = true;
    };

    services = {
      pulseaudio.enable = false;
      blueman.enable = true;
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

    # boot.initrd.luks.devices.storage = {
    #  device = "/dev/disk/by-label/STORAGE";
    #  keyFile = "/extkey.key";
    #  preLVM = true;
    #};
    #
  };
}
