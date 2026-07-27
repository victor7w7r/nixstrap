{ disko, ... }:
{
  den.aspects =
    with disko;
    let
      cloud = disk.lvm { device = "mapper/cloud"; };
      lvm_vg = xfs.lvm {
        name = "cloud";
        size = "3T";
        isRaid = true;
        logdev = "/dev/mapper/cloudlogcrypt";
        mountpoint = "/nix/persist/cloud";
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
      emmc = disk.gpt {
        device = "${disk.constants.id}/mmc-SCA256_0x3870d703";
        partitions = {
          esp = esp.call { };
          store = f2fs.call {
            name = "store";
            size = "150G";
            mountpoint = "/nix";
            priority = 2;
          };
          shared = f2fs.call {
            name = "shared";
            size = "100%";
            mountpoint = "/run/media/shared";
            priority = 3;
          };
        };
      };
      mdadm = {
        raid0 = {
          type = "mdadm";
          level = 5;
        };
      };
      nvme =
        {
          extraParts ? { },
        }:
        disk.gpt {
          device = "nvme0n1";
          partitions = {
            emergency = btrfs.emergency { priority = 1; };
          }
          // extraParts;
        };
    in
    {
      server.disks.nixos = {
        disko.devices = {
          inherit lvm_vg mdadm;
          disk = {
            inherit emmc cloud;
            root = disk.root { };
            nvme = nvme { };
          };
        };
      };
      server-physical-chroot.nixos.disko.devices = {
        inherit mdadm;
        disk = {
          nvme = nvme {
            extraParts = {
              # cryptsetup luksOpen /dev/disk/by-partlabel/disk-nvme-cloudlogcrypt cloudlogcrypt
              # cryptsetup luksOpen /dev/disk/by-partlabel/disk-nvme-cloudcachecrypt cloudcachecrypt
              # cryptsetup luksOpen /dev/disk/by-partlabel/disk-nvme-persist persist
              swapcrypt = luks.call {
                name = "swapcrypt";
                device = "${disk.constants.partlabel}/disk-nvme-swapcrypt";
                size = "16G";
                content = swap.call { };
                priority = 2;
              };
              cloudlogcrypt = luks.call {
                name = "cloudlogcrypt";
                size = "1G";
                device = "${disk.constants.partlabel}/disk-nvme-cloudlogcrypt";
                priority = 3;
              };
              cloudcachecrypt = luks.call {
                name = "cloudcachecrypt";
                size = "180G";
                device = "${disk.constants.partlabel}/disk-nvme-cloudcachecrypt";
                priority = 4;
                postCreate = "sudo make-bcache -B /dev/md/raid0 -C /dev/mapper/cloudcachecrypt";
              };
              persist = luks.call {
                name = "persist";
                size = "100%";
                device = "${disk.constants.partlabel}/disk-nvme-persist";
                allowDiscards = true;
                content = disko.xfs.call {
                  name = "persist";
                  mountpoint = "/nix/persist";
                  entireDisk = true;
                  isSolid = true;
                  isVmStorage = true;
                  extraOptions = [
                    "x-systemd.device-timeout=300"
                    "x-systemd.mount-timeout=300"
                  ];
                };
              };
            };
          };
          inherit emmc;
          cloud1 = disk.mdraid { device = "ata-MM1000GBKAL_9XG3YGXQ"; };
          cloud2 = disk.mdraid { device = "ata-WDC_WD10EZEX-60ZF5A0_WD-WMC1S2944154"; };
          cloud3 = disk.mdraid { device = "ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H"; };
          cloud4 = disk.mdraid { device = "ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X"; };
          cloud5 = disk.mdraid { device = "ata-TOSHIBA_DT01ACA100_Y7JAA68MS"; };
        };
      };
      server-logical-chroot.nixos.disko.devices = {
        inherit lvm_vg;
        disk = {
          inherit cloud;
          bcache = luks.entire {
            name = "cloud";
            device = "/dev/bcache0";
            postMount = ''
              #cryptsetup open ${disk.constants.partlabel}/disk-nvme-cloudcachecrypt cloudcachecrypt --key-file /tmp/key.txt || true
              #cryptsetup open ${disk.constants.partlabel}/disk-nvme-cloudlogcrypt cloudlogcrypt --key-file /tmp/key.txt || true
            '';
          };
        };
      };
    };
}

/*
  --create /dev/md/raid0 --level=5 --raid-devices=5  \
   sudo bcache unregister /dev/md127
   sudo mdadm --stop /dev/md127
   sudo mdadm \
   --assemble /dev/md/raid0 --name=raid0 --update=name \
   /dev/disk/by-id/ata-MM1000GBKAL_9XG3YGXQ \
   /dev/disk/by-id/ata-WDC_WD10EZEX-60ZF5A0_WD-WMC1S2944154 \
   /dev/disk/by-id/ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H \
   /dev/disk/by-id/ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X \
   /dev/disk/by-id/ata-TOSHIBA_DT01ACA100_Y7JAA68MS
   sudo bcache register /dev/md/raid0
   sudo cryptsetup open /dev/disk/by-partlabel/disk-nvme-persist persist --key-file=/tmp/key.txt
   sudo cryptsetup open /dev/disk/by-partlabel/disk-nvme-cloudcachecrypt cloudcachecrypt --key-file /tmp/key.txt
   sudo cryptsetup open /dev/disk/by-partlabel/disk-nvme-cloudlogcrypt cloudlogcrypt --key-file /tmp/key.txt
*/
