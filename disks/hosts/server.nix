let
  zfsFor: {
    pool ? "zroot",
    size ? "100%"
  } = {
    inherit size;
    content = {
      type = "zfs";
      inherit pool;
    };
  };

  hddFor: {
    device,
    pool ? "zcloud",
  } = {
    type = "disk";
    device = "/dev/disk/by-id/${device}";
    content = {
      type = "gpt";
      partitions = zfsFor { inherit pool; };
    };
  };

  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    system = (import ../lib/f2fs.nix) {
      label = "serversys";
      name = "serversys";
      size = "100%";
      isIsolated = true;
      priority = 2;
    };
  };

  nvmepartitions = {
    emergency = (import ../filesystems/emergency.nix) { priority = 1; };
    zfssystem = zfsFor { size = "120G"; }; #Log, 2GB -> #Special 40GB, #Cache 78GB
    zfscloud =  zfsFor { pool = "zcloud"; };  #Log, 16GB -> #Special 100GB, #Cache 120GB, #Shared rest
  };
in
{
  disko.devices = {
    disk = {
      emmc = {
        type = "disk";
        device = "/dev/mmcblk0";
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
      cloud1 = hddFor {
        device = "ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X";
      };
      cloud2 = hddFor {
        device = "ata-MM1000GBKAL_9XG3YGXQ";
      };
      cloud3 = hddFor {
        device = "ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H";
      };
      cloud4 = hddFor {
        device = "ata-TOSHIBA_MQ01ABD100_46G8SH1BST";
      };
      store = hddFor {
        device = "ata-ST500LT012-1DG142_S3PMCMHT";
        pool = "zroot";
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        mountpoint = "/storage";
        datasets = {
          dataset = {
            type = "zfs_fs";
            mountpoint = "/storage/dataset";
          };
        };
      };
      zcloud = {
        type = "zpool";
        mountpoint = "/storage2";
        rootFsOptions = {
          canmount = "off";
        };
        datasets = {
          dataset = {
            type = "zfs_fs";
            mountpoint = "/storage2/dataset";
          };
        };
      };
    };
  };
}
