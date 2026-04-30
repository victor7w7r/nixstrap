let
  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    store = (import ../lib/f2fs.nix) {
      name = "store";
      size = "150G";
      mountpoint = "/nix";
      priority = 2;
    };
    shared = (import ../lib/f2fs.nix) {
      name = "shared";
      size = "100%";
      mountpoint = "/nix/persist/shared";
      priority = 3;
    };
  };

  nvmepartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    swapcrypt = (import ../lib/luks.nix) {
      name = "swapcrypt";
      size = "16G";
      group = "nvme";
      content = (import ../lib/swap.nix) { };
      priority = 3;
    };
    cloudlogcrypt = (import ../lib/luks.nix) {
      name = "cloudlogcrypt";
      size = "1G";
      group = "nvme";
      priority = 4;
    };
    cloudcachecrypt = (import ../lib/luks.nix) {
      name = "cloudcachecrypt";
      size = "nvme";
      group = "ssd";
      priority = 5;
      postCreate = "make-bcache -C /dev/mapper/cloudcachecrypt";
    };
    persist = (import ../lib/xfs.nix) {
      name = "persist";
      size = "100%";
      mountpoint = "/nix/persist";
      isSolid = true;
      isVmStorage = true;
    };
  };

  lvs = {
    thinpool = {
      size = "3.5G";
      lvm_type = "thin-pool";
    };
    persist = (import ../lib/xfs.nix) {
      name = "persist";
      size = "100%";
      mountpoint = "/nix/persist/cloud";
      logdev = "/dev/mapper/cloudlogcrypt";
      isRaid = true;
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";
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

      bcache0 = {
        type = "disk";
        device = "/dev/bcache0";
        content = {
          vg = "vg0";
          type = "lvm_pv";
        };
      };

      node."/tmp" = {
        fsType = "tmpfs";
        mountOptions = [ "size=2G" ];
      };

      lvm_vg.vg0 = {
        type = "lvm_vg";
        inherit lvs;
      };

      cloud1 = {
        type = "disk";
        device = "${idpart}/ata-MM1000GBKAL_9XG3YGXQ";
        content = {
          type = "mdraid";
          name = "raid0";
          size = "100%";
        };
      };

      cloud2 = {
        type = "disk";
        device = "${idpart}/ata-WDC_WD10EZEX-60ZF5A0_WD-WMC1S2944154";
        content = {
          type = "mdraid";
          name = "raid0";
          size = "100%";
        };
      };

      cloud3 = {
        type = "disk";
        device = "${idpart}/ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H";
        content = {
          type = "mdraid";
          name = "raid0";
          size = "100%";
        };
      };

      cloud4 = {
        type = "disk";
        device = "${idpart}/ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X";
        content = {
          type = "mdraid";
          name = "raid0";
          size = "100%";
        };
      };

      cloud5 = {
        type = "disk";
        device = "${idpart}/ata-TOSHIBA_DT01ACA100_Y7JAA68MS";
        content = {
          type = "mdraid";
          name = "raid0";
          size = "100%";
        };
      };

      mdadm.raid0 = {
        type = "mdadm";
        level = 4;
        content = (import ../lib/luks.nix) {
          entireDisk = true;
          allowDiscards = false;
          name = "cloud";
          size = "100%";
          group = "cloud"; # FIX
          postMount = ''
            cryptsetup open ${partlabel}/disk-nvme-cloudcachecrypt cloudcachecrypt --key-file /tmp/key.txt || true
            cryptsetup open ${partlabel}/disk-nvme-cloudlogcrypt cloudlogcrypt --key-file /tmp/key.txt || true
          '';
          postCreate = ''
            make-bcache -B /dev/mapper/cloud
            #CACHE_SET_UUID=$(sudo bcache-super-show /dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36-part9 | grep 'cset.uuid' | awk '{print $2}')
            #echo $CACHE_SET_UUID > /sys/block/bcache1/bcache/attach
          '';
        };
      };
    };
  };
}
