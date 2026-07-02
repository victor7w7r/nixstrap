{ disko, ... }:
{
  den.aspects.server.disks-physical.nixos =
    { ... }:
    let
      partlabel = "/dev/disk/by-partlabel";
      idpart = "/dev/disk/by-id";

      mmcpartitions = {
        esp = disko.esp.call { };
        store = disko.f2fs.call {
          name = "store";
          size = "150G";
          mountpoint = "/nix";
          priority = 2;
        };
        shared = disko.f2fs.call {
          name = "shared";
          size = "100%";
          mountpoint = "/run/media/shared";
          priority = 3;
        };
      };

      nvmepartitions = {
        emergency = disko.btrfs.emergency { priority = 1; };
        swapcrypt = disko.luks.call {
          name = "swapcrypt";
          device = "${partlabel}/disk-ssd-swapcrypt";
          size = "16G";
          content = disko.swap.call { };
          priority = 2;
        };
        cloudlogcrypt = disko.luks.call {
          name = "cloudlogcrypt";
          size = "1G";
          device = "${partlabel}/disk-nvme-cloudlogcrypt";
          priority = 3;
        };
        cloudcachecrypt = disko.luks.call {
          name = "cloudcachecrypt";
          size = "180G";
          device = "${partlabel}/disk-nvme-cloudcachecrypt";
          priority = 4;
          postCreate = "sudo make-bcache -B /dev/md/raid0 -C /dev/mapper/cloudcachecrypt";
        };
        persist = disko.luks.call {
          name = "persist";
          size = "100%";
          device = "${partlabel}/disk-nvme-persist";
          priority = 5;
          content = disko.xfs.call {
            name = "persist";
            mountpoint = "/nix/persist";
            entireDisk = true;
            isSolid = true;
            isVmStorage = true;
          };
        };
      };

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
    in
    {
      disko.devices = {
        disk = {
          emmc = {
            type = "disk";
            device = "/dev/disk/by-id/mmc-SCA256_0x3870d703";
            content = {
              type = "gpt";
              partitions = mmcpartitions;
            };
          };

          nvme = {
            type = "disk";
            device = "/dev/nvme0n1";
            content = {
              type = "gpt";
              partitions = nvmepartitions;
            };
          };

          /*
            cloud1 = {
              type = "disk";
              device = "${idpart}/ata-MM1000GBKAL_9XG3YGXQ";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };

            cloud2 = {
              type = "disk";
              device = "${idpart}/ata-WDC_WD10EZEX-60ZF5A0_WD-WMC1S2944154";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };

            cloud3 = {
              type = "disk";
              device = "${idpart}/ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };

            cloud4 = {
              type = "disk";
              device = "${idpart}/ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };

            cloud5 = {
              type = "disk";
              device = "${idpart}/ata-TOSHIBA_DT01ACA100_Y7JAA68MS";
              content = {
                type = "mdraid";
                name = "raid0";
              };
              };
          */
        };

        mdadm.raid0 = {
          type = "mdadm";
          level = 5;
        };
      };
    };
}
