{ pkgs, lib, ... }:
with lib;
{
  powerManagement.cpuFreqGovernor = "ondemand";

  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = rec {
      maindevice = "/dev/nvme0n1";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg0-home";
      varDisk = "/dev/mapper/vg0-var";
      gameDisk = "/dev/disk/by-partlabel/disk-main-games";
      kvmDisk = "";
      extraDir = "games";
      extraMount = ''
        mount -t btrfs -o noatime,lazytime,nodiscard,compress-force=zstd:3,commit=60 ${gameDisk} /sysroot/games
      '';
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

    boot = {
      initrd = {
        luks.devices = {
          system = {
            device = "/dev/disk/by-label/SYSTEM";
            #keyFile = "/syskey.key";
            allowDiscards = true;
            preLVM = true;
          };
        };
        secrets = {
          #"/syskey.key" = /run/secrets/syskey.key;
        };
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
  };
}
