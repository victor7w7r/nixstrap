{ disko, lib, ... }:
{
  den.aspects.server.disks-logical.nixos =
    let
      partlabel = "/dev/disk/by-partlabel";
      lvs = {
        thinpool = {
          size = "100%";
          lvm_type = "thin-pool";
        };
        cloud = disko.xfs.call {
          size = "3T";
          mountpoint = "/nix/persist/cloud";
          logdev = "/dev/mapper/cloudlogcrypt";
          isRaid = true;
          nameLvm = "cloud";
          extraSetupDisk = {
            pool = "thinpool";
            lvm_type = "thinlv";
          };
        };
      };
    in
    {
      fileSystems = {
        "/nix/persist".neededForBoot = true;
        "/" = lib.mkDefault {
          device = "/dev/zram1";
          fsType = "ext4";
          neededForBoot = true;
          options = [
            "noatime"
            "x-systemd.device-timeout=0"
          ];
        };
      };

      disko.devices = {
        disk = {
          bcache = {
            type = "disk";
            device = "/dev/bcache0";
            content = disko.luks.call {
              entireDisk = true;
              allowDiscards = false;
              name = "cloud";
              size = "100%";
              device = "/dev/bcache0";
              postMount = ''
                cryptsetup open ${partlabel}/disk-nvme-cloudcachecrypt cloudcachecrypt --key-file /tmp/key.txt || true
                cryptsetup open ${partlabel}/disk-nvme-cloudlogcrypt cloudlogcrypt --key-file /tmp/key.txt || true
              '';
            };
          };

          cloud = {
            type = "disk";
            device = "/dev/mapper/cloud";
            content = {
              type = "lvm_pv";
              vg = "vg0";
            };
          };

        };
        lvm_vg.vg0 = {
          type = "lvm_vg";
          inherit lvs;
        };
      };
    };
}

/*
  let
    helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
    kernelBuild = (pkgs.callPackage ../kernel) {
      inherit
        helpers
        host
        kernelData
        inputs
        ;
    };
    params = import ./lib/kernel-params.nix;
    boot = (import ./lib/boot.nix) {
      efiDisk = "emmc";
      emergencyDisk = "nvme";
    };
    f2fs = import ./lib/f2fs.nix;
    xfs = (import ./lib/xfs.nix);
  in
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = {
      device = "/dev/zram1";
      fsType = "ext4";
      neededForBoot = true;
      options = [
        "noatime"
        "x-systemd.device-timeout=0"
      ];
    };

    "/run/media/shared" = f2fs {
      label = "shared";
      neededForBoot = false;
    };

    "/nix" = f2fs {
      label = "store";
      depends = [ "/" ];
    };

    "/nix/persist" = xfs {
      depends = [ "/nix" ];
      device = "/dev/mapper/persist";
      extraOptions = [
        "x-systemd.device-timeout=300"
        "x-systemd.mount-timeout=300"
      ];
    };

    "/nix/persist/cloud" = xfs {
      depends = [ "/nix/persist" ];
      device = "/dev/vg0/cloud";
      extraOptions = [
        "largeio"
        "swalloc"
        "sunit=1024"
        "swidth=4096"
        "inode64"
        "logdev=/dev/mapper/cloudlogcrypt"
        "x-systemd.device-timeout=300"
        "x-systemd.mount-timeout=300"
      ];
    };
  };
*/
